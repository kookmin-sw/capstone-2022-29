const { response } = require("express");
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
    // user_id을 query로 넘기면 user_id만 filtering
    const regexUID = new RegExp(req.query.user_id);
    // query를 query로 넘기면 query만 filtering
    const regexQuery = new RegExp(req.query.query);
    // user_id와 query를 둘 다 넘기면 둘다 filtering
    await Bubble.find(
        {'user_id': {'$regex': regexUID}, 'bubble':{'$elemMatch':{'query': {'$regex': regexQuery}}}}, 
        function(err, bubble){
            if(err) return res.status(500).json({ error: err });
            if(!bubble) return res.status(404).json({ error: '해당 회원의 버블이 존재하지 않습니다.' });
            res.json(bubble);
        }
    ).clone().catch(function(err){console.log(err)});
};

const updateBubble = async (req, res) => { // -> 사용자의 bubble의 query가 있으면 count+1, query가 없으면 새로 추가
    const regexUID = new RegExp(req.query.user_id);

    if(req.query.query == undefined){
        await Bubble.findOneAndUpdate(
            {'user_id': {'$regex': regexUID}}, 
            {$addToSet: {'bubble': {'query': req.body.bubble.query}}},
            function(err){
                if(err){
                    console.error(err);
                    res.json({ message : 'fail' });
                    return;
                }
                res.json({ message : 'success' });
            }
        ).catch(function(err){console.log(err)});
    }
    else{
        const regexQuery = new RegExp(req.query.query);

        await Bubble.findOneAndUpdate(
            {'user_id': {'$regex': regexUID}}, 
            {$inc: {'bubble.$[elem].count': 1}},
            {arrayFilters: [{'elem.query': {'$regex': regexQuery}}]},
            function(err){
                if(err){
                    console.error(err);
                    res.json({ message : 'fail' });
                    return;
                }
                res.json({ message : 'success' });
            }
        ).catch(function(err){console.log(err)});
    }
}

module.exports = {
    postBubble,
    getBubble,
    updateBubble,
}