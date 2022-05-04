const models = require("../models");

const Notice = models.Notice;

const postNotice = async (req, res) => {
    const newNotice = new Notice(req.body);
    await newNotice.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
            return;
        }
        res.json({ message : 'success' });
    });
};

const getNotice = async (req, res) => {
    await Notice.find(function(err, notice){
        if(err) return res.status(500).json({ error: err });
        if(!notice) return res.status(404).json({ error: '뉴스가 존재하지 않습니다.' });
        res.json(notice);
    }).clone().catch(function(err){console.log(err)});
};

module.exports = {
    postNotice,
    getNotice,
}