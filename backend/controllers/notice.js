const models = require("../models");

const Notice = models.Notice;

const postNotice = async (req, res) => {
    const newNotice = new Notice(req.body);
    await newNotice.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
        }
        res.json({ message : 'success' });
    });
};

const getNotice = async (req, res) => {
    await Notice.find()
    .then(notice => {
        if(!notice) res.status(404).json({ error: '공지사항이 존재하지 않습니다.' });
        else res.json(notice);
    }).catch(err => res.status(500).json({ error: err }));
};

module.exports = {
    postNotice,
    getNotice,
}