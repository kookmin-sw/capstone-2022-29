require("dotenv").config();

const express = require('express');
const app = express();
const bodyParser = require("body-parser");

const mongoose = require('mongoose');
mongoose
    .connect(process.env.MONGODB_URI, {
        useNewUrlParser: true, useUnifiedTopology: true,
    })
    .then(() => console.log("MongoDB Connected"))
    .catch((err) => console.log(err));

// app.all('/*', function (req, res, next) {
//	    res.header('Access-Control-Allow-Origin', '*')
//	    res.header('Access-Control-Allow-Headers', 'X-Requested-With')
//	    next()
// });

const cors = require('cors');
const corsOptions = {
	origin: '*',
	origin: true,
};

app.use(cors(corsOptions));

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.get("/", (req, res) => res.send("Node js & MongoDB Connected"));

const router = require("./router");
app.use('/', router);

// const newsSchema = require('./models/news');
// require('./controllers/news')(app, newsSchema);

// const userSchema = require('./models/user');
// require('./routes/user')(app, userSchema);

const PORT = process.env.PORT || 5000;
app.listen(PORT, (err, res) => {
    if(err) throw err;
    console.log("Node js & MongoDB Connected");
});
