const models = require("../models");

const QA = models.QA;

const postQA = async (req, res) => {
    const newQA = new QA(req.body);
    await newQA.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
        }
        res.json({ message : 'success' });
    });
};

const getQA = async (req, res) => {
    await QA.find()
    .then(qa => {
        if(!qa) res.status(404).json({ error: 'Q&A가 존재하지 않습니다.' });
        else res.json(qa);
    }).catch(err => res.status(500).json({ error: err }));
};

module.exports = {
    postQA,
    getQA,
}