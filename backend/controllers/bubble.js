const models = require("../models");

const Bubble = models.Bubble;

const postBubble = async (req, res) => { // -> 사용자가 한번도 bubble을 등록 X
    const newBubble = new Bubble(req.body);
    await newBubble.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
            return;
        }
        res.json({ message : 'success' });
    });
};

const getBubble = async (req, res) => { // -> 사용자의 bubble을 조회할 때
    const regex = new RegExp(req.query.user_id);
    await Bubble.find({'user_id':{'$regex':regex}}, function(err, bookmark){
        if(err) return res.status(500).json({ error: err });
        if(!bookmark) return res.status(404).json({ error: '해당 회원의 버블이 존재하지 않습니다.' });
        res.json(bookmark);
    }).clone().catch(function(err){console.log(err)});
};

const getBubbleQuery = async (req, res) => { // -> 사용자의 bubble의 query가 있는지 조회할 때
    await Bubble.find(
        {'$and':[{user_id: req.query.user_id}, {query: req.query.query}]},
        function(err, bookmark){
            if(err) return res.status(500).json({ error: err });
            if(!bookmark) return res.status(404).json({ error: '해당 회원의 버블이 존재하지 않습니다.' });
            res.json(bookmark);
        }
    ).clone().catch(function(err){console.log(err)});
};

const getAllBubble = async (req, res) => { // -> search page 의 ranking 을 위함
    await Bubble.find(function(err, bubble){
        if(err) return res.status(500).json({ error: err });
        if(!bubble) return res.status(404).json({ error: '버블이 존재하지 않습니다.' });
        res.json(bubble);
    }).clone().catch(function(err){console.log(err)});
};

const updateBubble = async (req, res) => { // -> 사용자가 이전에 bubble을 등록 O
    await Bubble.updateOne(
        {user_id: req.query.user_id},
        {$push: {'bubble': {'query': req.body.bubble.query, 'count': req.body.bubble.count}}},
    ).clone().catch(function(err){console.log(err)});
}

const updateBubbleCount = async (req, res) => { // -> 사용자가 bubble의 count를 증가시킬 때
    await Bubble.updateOne(
        {user_id: req.query.user_id, query: req.query.query},
        {$push: {'bubble': {'count': req.body.bubble.count}}},
    ).clone().catch(function(err){console.log(err)});
}

module.exports = {
    // bubble
    postBubble,
    getBubble,
    updateBubble,
    getAllBubble,
    getBubbleQuery,
    updateBubbleCount,
}