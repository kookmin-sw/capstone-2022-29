const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    access_token: { type: String, required: true },
    nickname: { type: String, required : true },
    profile: { type: String, required : true },
    // email: { type: String },
}, { collection: "users" });

const NewsSchema = new mongoose.Schema({
    journal: { type: String, required: true },
    date: { type: String, required: true },
    title: { type: String, required : true },
    url: { type: String, required:true },
    content: { type: String, required : true },
    summary: { type: String, required: true },
}, { collection: "news" });

const BubbleSchema = new mongoose.Schema({ // -> Bubble chart(user_id 로 찾음), Ranking(전체 user)
    user_id: { type: String, required: true }, // ObjectId
    // query: { type: String, required : true },
    // count: { type: Number, required: true }, // 검색어 -> 토픽 -> 뉴스 기사 클릭하면 count+1
    bubble: {
        type: Array,
        of: {
            query: { type: String, required: true },
            count: { type: Number, required: true },
        },
        required: true
    },
}, { collection: "bubbles" });

const TopicSchema = new mongoose.Schema({
    query: { type: String, required : true },
    topicNum: {
        type: Array,
        of: {
            num: { type: Number, required: true },
            topics: {
                type: Array,
                of: {
                    date: { type: String, required: true },
                    topic: { type: String, required: true },
                    news: {
                        type: Array,
                        of: {
                            news_id: { type: String, required: true },
                        }
                    }
                }
            }
        }
    }

}, { collection: "topics" });

const BookmarkSchema = new mongoose.Schema({
    user_id: { type: String, required : true },
    bookmark: {
        type: Array,
        of: {
            news_id: { type: String, required : true },
            query: { type: String, required : true },
            topic: { type: String, required: true },
        }
    }
}, { collection: "bookmarks" });

const KeywordSchema = new mongoose.Schema({
    user_id: { type: String, required : true },
    keywords: {
        type: Array,
        of: {
            keyword: { type: String, required: true },
        }
    }
}, { collection: "keywords" });

const User = mongoose.model("User", UserSchema);
const News = mongoose.model("News", NewsSchema);
const Bubble = mongoose.model("Bubble", BubbleSchema);
const Topic = mongoose.model("Topic", TopicSchema);
const Bookmark = mongoose.model("Bookmark", BookmarkSchema);
const Keyword = mongoose.model("Keyword", KeywordSchema);

module.exports = {
    User,
    News,
    Bubble,
    Topic,
    Bookmark,
    Keyword,
};