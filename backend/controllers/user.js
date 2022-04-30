const models = require("../models");

const User = models.User;

const postUserInfo = async (req, res) => {
    const newUser = new User(req.body);
    await newUser.save(function(err){
        if(err){
            console.error(err);
            res.json({ message : 'fail' });
            return;
        }
        res.json({ message : 'success' });
    });
};

const getUserInfo = async (req, res) => {
    const regex = new RegExp(req.query.nickname);
    await User.find(
        {'nickname':{'$regex':regex}}, 
        function(err, user){
            if(err) return res.status(500).json({ error: err });
            if(!user) return res.status(404).json({ error: '해당 회원이 존재하지 않습니다.' });
            res.json(user);
        }
    ).clone().catch(function(err){console.log(err)});
};

// const getAllUserInfo = async (req, res) => {
//     await User.find(function(err, user){
//             if(err) return res.status(500).json({ error: err });
//             if(!user) return res.status(404).json({ error: '회원이 존재하지 않습니다.' });
//             res.json(user);
//     }).clone().catch(function(err){console.log(err)});
// };

const updateUser = async (req, res) => {
    await User.updateOne(
        {nickname: req.query.nickname},
        {$set: req.body},
    ).clone().catch(function(err){console.log(err)});
}

module.exports = {
    postUserInfo,
    getUserInfo,
    updateUser,
    // getAllUserInfo,
}