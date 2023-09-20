/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
// 一旦消去
// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// openai連携
// const functions = require("firebase-functions");
// const openai = require("openai");

// openai.apiKey = functions.config().openai.key;

// exports.makeChatGentler = functions.https.onCall(
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

// const functions = require('firebase-functions');

// exports.makeChatGentler = functions.https.onCall
// ((data, context) => {
//   const message = data.message;
//   const gentlerMessage = message.replace
//   ('hate', 'dislike').replace('stupid', 'not smart');
//   return { message: gentlerMessage };
// });

// const functions = require("firebase-functions");

// exports.makeChatGentler = functions.https.onCall(
//     (data, context) => {
//       console.log("Function was called with data:", data);
//       return {"message": "もしかしてはろーわーるど？"};
//     });
// テキスト言い換え
// const functions = require("firebase-functions");

// exports.makeChatGentler = functions.https.onCall((
//     data, context) => {
//   const message = data.text;
//   const gentlerMessage = message.replace(
//       /嫌い/g, "好きじゃない").replace(
//       /あほ/g, "あほみがある");
//   return {message: gentlerMessage};
// });

const functions = require("firebase-functions");
const openai = require("openai");

openai.apiKey =
"dummydummy";
/**
 * This function takes a message as input
 * and rephrases it to be more polite if necessary.
 *
 * @param {string} message - The message to analyze and potentially rephrase.
 * @return {string} - The original or rephrased message.
 */
function analyzeAndRephrase(message) {
  if (message.includes("こんにちは")) {
    message = "語尾ににゃー";
  }

  return message;
}

exports.chatGPT = functions.https.onCall(
    async (data, context) => {
      try {
      // Get the original text
        const originalText = data.text;

        // Analyze and rephrase the text
        const rephrasedText = analyzeAndRephrase(originalText);

        const response = await openai.Completion.create({
          engine: "davinci",
          prompt: `優しい夫/妻の視点から次のメッセージに返信してください
          ネガティブな表現はそのままにせずなるべくポジティブな要素を
          加えるようにしてください: 
          "${rephrasedText}"`,
          max_tokens: 150,
        });

        // Return the response from GPT-3
        return {message: response.choices[0].text.trim()};
      } catch (error) {
        console.error(error);
        return {message: "Error generating response."};
      }
    });


