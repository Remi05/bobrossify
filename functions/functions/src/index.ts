import * as functions from 'firebase-functions';
import { storage } from 'firebase-admin';

const gcs = require('@google-cloud/storage');
const path = require('path');
const os = require('os');
const fs = require('fs');
const mkdirp = require('mkdirp-promise');
const spawn = require('child-process-promise').spawn;
const admin = require('firebase-admin');
const gm = require('gm').subClass({imageMagick: true});

admin.initializeApp();

const BACKGROUND_IMG_PATH = 'bobross.jpg';

exports.bobrossifyImage = functions.storage.object().onFinalize(async (object) => {
    // Exit if this is triggered on a file that is not an image.
    if (!object.contentType.startsWith('image/')) {
        return null;
    }

    // Exit if this is triggered on a file that is not in the 'images' folder.
    const rootDir = path.dirname(object.name);
    if (!rootDir.startsWith('images')) {
        return null;
    }

    const bucket = admin.storage().bucket(object.bucket);
    
    // Create local tmp source directory.
    const srcFilePath = object.name;
    const tmpSrcFile = path.join(os.tmpdir(), srcFilePath);
    const tmpLocalSrcDir = path.dirname(tmpSrcFile);
    await mkdirp(tmpLocalSrcDir);

    // Download original file from bucket.
    await bucket.file(srcFilePath).download({destination: tmpSrcFile});
    console.log('Original image downloaded to', tmpSrcFile);

    // Download background file from bucket.
    const tmpBackgroundFile = path.join(os.tmpdir(), BACKGROUND_IMG_PATH);
    await bucket.file(BACKGROUND_IMG_PATH).download({destination: tmpBackgroundFile});
    console.log('Background image downloaded to', tmpBackgroundFile);

    // Create local tmp destination directory.
    const outDirName = 'output';
    const fileExt = path.extname(srcFilePath);
    const fileName = path.basename(srcFilePath, fileExt);

    const dstFilePath = path.format({
        dir: outDirName,
        name: `${fileName}_bobrossified`,
        ext: fileExt
      });
    // const tmpDstFile = path.join(os.tmpdir(), dstFilePath);
    const tmpDstFile = path.format({
        dir: path.dirname(srcFilePath),
        name: `${fileName}_bobrossified`,
        ext: fileExt
      });
    const tmpLocalDstDir = path.dirname(tmpSrcFile);
    // await mkdirp(tmpLocalDstDir);

    // Modify the image.
    await spawn('convert', [tmpBackgroundFile, tmpSrcFile, '-gravity', 'center', '-composite', tmpDstFile]);
    console.log('Modified image created at', tmpDstFile);
    
    // Upload the image.
    await bucket.upload(tmpDstFile, {destination: dstFilePath});
    console.log('Modified image uploaded to Storage at', dstFilePath);

    // Delete the local files to free up disk space.
    fs.unlinkSync(tmpDstFile);
    fs.unlinkSync(tmpSrcFile);
    return null;
});