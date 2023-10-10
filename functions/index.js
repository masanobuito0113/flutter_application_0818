/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */


// openai連携
// global.AbortController = require("abort-controller").AbortController;

const functions = require("firebase-functions");
const openai = require("openai");

openai.apiKey = functions.config().openai.key;

// exports.makeGentler = functions.https.onCall(
//     async (data, context) => {
//       const message = data.message;

//       try {
//         // 次は、仮のロジックです：
//         const gentlerMessage =
//       message.replace("hate", "dislike").replace(
//           "stupid", "not smart");

//         return {message: gentlerMessage};
//       } catch (error) {
//         console.error("Error:", error);
//         throw new functions.https.HttpsError(
//             "internal",
//             "An internal error occurred.");
//       }
//     });
exports.makeChatGentler = functions.https.onCall((
    data, context) => {
  const message = data.text;
  const gentlerMessage = message.replace(
      /ばか/g, "好きじゃない").replace(
      /あほ/g, "あほみがある");
  return {message: gentlerMessage};
});
