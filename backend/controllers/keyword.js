const models = require("../models");

const Keyword = models.Keyword;

const postKeyword = async (req, res) => { // -> 사용자가 한번도 keyword를 등록 X
    const newKeyword = new Keyword(req.body);
    await newKeyword.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
            return;
        }
        res.json({ message : 'success' });
    });
};

const getKeyword = async (req, res) => { // -> 사용자의 keyword를 조회할 때
    const regex = new RegExp(req.query.user_id);
    await Keyword.find(
        {'user_id': {'$regex': regex}},
        function(err, keyword){
            if(err) return res.status(500).json({ error: err });
            if(!keyword) return res.status(404).json({ error: '해당 사용자의 키워드가 존재하지 않습니다.' });
            res.json(keyword);
        }
    ).clone().catch(function(err){console.log(err)});
};

const updateKeyword = async (req, res) => { // -> 사용자가 keyword를 등록한 적이 있으면 update
    const regexUID = new RegExp(req.query.user_id);
    if(req.query.keyword == undefined){
        await Keyword.findOneAndUpdate( // 사용자의 기존 keyword에 새로운 keyword 추가
            {'user_id': {'$regex': regexUID}}, 
            {$addToSet: {'keywords': {'keyword': req.body.keywords.keyword}}},
            // function(err){
            //     if(err){
            //         console.error(err);
            //         res.json({ message : 'fail' });
            //         return;
            //     }
            //     res.json({ message : 'success' });
            // }
        )
        .then(res.json({ message: 'success' }))
        .catch(err => {
            console.error(err);
            res.json({ message : 'fail' });
        });
    }
    else{
        const regexKeyword = new RegExp(req.query.keyword);
        await Keyword.findOneAndUpdate( // 사용자의 기존 keyword에서 원하는 keyword 삭제
            {'user_id': {$regex: regexUID}},
            {$pull: {'keywords': {'keyword': {$regex: regexKeyword}}}},
            {new: true},
            // function(err, keyword){
            //     if(err) return res.status(500).json({ error: err });
            //     if(!keyword) return res.status(404).json({ error: '해당 사용자의 키워드가 존재하지 않습니다.' });
            //     res.json(keyword);
            // }
        )
        .then(keyword => {
            if(!keyword) res.status(404).json({ error: '해당 사용자의 키워드가 존재하지 않습니다.' });
            else res.json(keyword);
        })
        .catch(err => res.status(500).json({ error: err }));
    }
}

module.exports = {
    postKeyword,
    getKeyword,
    updateKeyword,
}