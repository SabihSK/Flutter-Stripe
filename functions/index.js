const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const stripe = require('stripe')(functions.config().stripe.testkey);

exports.stripePayment = functions.https.onRequest(async (req, res) => {

    stripe.customers.create({
        email: req.body.stripeEmail,
        source: req.body.stripeToken,
        phone: req.body.phone,
        name: req.body.name,
    })
        .then(customer => stripe.charges.create({
            amount: 799,
            description: 'home purchase',
            currency: 'usd',
            customer: customer.id
        })).catch((err) => { console.log(err) })
        .then(charge => {

            return res.json({ "paid": 'true' })

        })




    // const paymentIntent = await stripe.paymentIntents.create({
    //     amount: 19.99,
    //     currency: 'gbp'
    // },
    //     function (err, paymentIntent) {
    //         if (err != null) {
    //             console.log(err);
    //         }
    //         else {
    //             res.json({
    //                 paymentIntent: paymentIntent.client_secret
    //             })
    //         }
    //     }
    // )
}
)