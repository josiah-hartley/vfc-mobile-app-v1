const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

exports.getMessagesSinceDate = functions.https.onRequest((req, res) => {
    let timemarker = Number(req.query.time);
    let matchingMessages = {};

    let query = db.collection('messageData').where('created', '>=', timemarker);
    query.get().then((snapshot) => {
        snapshot.forEach((doc) => {
            matchingMessages[doc.id] = doc.data();
        });
        res.status(200).send(matchingMessages);
    }).catch((err) => {
        res.status(500).send('Error processing request');
    });
});

exports.getSpeakers = functions.https.onRequest((req, res) => {
    let speakers = {};
    let query = db.collection('speakerData');
    query.get().then((snapshot) => {
        snapshot.forEach((doc) => {
            speakers[doc.id] = doc.data();
        });
        res.status(200).send(speakers);
    }).catch((err) => {
        res.status(500).send('Error processing request');
    });
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
