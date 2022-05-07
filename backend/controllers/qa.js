const models = require("../models");

const QA = models.QA;

const postQA = async (req, res) => {
    const newQA = new QA(req.body);
    await newQA.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
            return;
        }
        res.json({ message : 'success' });
    });
};

const getQA = async (req, res) => {
    await QA.find(function(err, qa){
        if(err) return res.status(500).json({ error: err });
        if(!qa) return res.status(404).json({ error: 'Q&A가 존재하지 않습니다.' });
        res.json(qa);
    }).clone().catch(function(err){console.log(err)});
};

module.exports = {
    postQA,
    getQA,
}