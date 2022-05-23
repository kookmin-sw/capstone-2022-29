const models = require("../models");

const Word = models.Word;

const postWord = async (req, res) => {
    const newWord = new Word(req.body);
    await newWord.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
        }
        res.json({ message : 'success' });
    });
};

const getWord = async (req, res) => {
    await Word.find()
    .then(word => {
        if(!word) res.status(404).json({ error: '검색어가 존재하지 않습니다.' });
        else res.json(word);
    }).catch(err => res.status(500).json({ error: err }));
};

module.exports = {
    postWord,
    getWord,
}