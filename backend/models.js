const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    nickname: { type: String, required : true },
    profile: { type: String, required : true },
    id: { type: String, required : false },
    password : { type: String, required : false },
    access_token: { type: String, required: true },
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
    bubble: {
        type: Array,
        of: {
            query: { type: String, required: true },
            count: { type: Number, required: true, default: 1 }, // 검색어 -> 토픽 -> 뉴스 기사 클릭하면 count+1
        },
        required: true
    },
}, { collection: "bubbles" });

const TopicSchema = new mongoose.Schema({
    query: { type: String, required : true },
    topicNum: {
        type: Array,
        of: {
            num: { type: Number, required: true }, // 0, 1, 2
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

const NoticeSchema = new mongoose.Schema({
    title: { type: String, required: true },
    content: { type: String, required : true },
}, { collection: "notices" });

const QASchema = new mongoose.Schema({
    title: {type: String, required: true},
    content: {type: String, required: true},
    receiver: {type: String, required: true},
}, {collection: "QA"});

const RequestSchema = new mongoose.Schema({
    title: {type: String, required: true},
}, {collection: "requests"});

const WordSchema = new mongoose.Schema({
    word: {type: String, required: true},
}, {collection: "words"});

const User = mongoose.model("User", UserSchema);
const News = mongoose.model("News", NewsSchema);
const Bubble = mongoose.model("Bubble", BubbleSchema);
const Topic = mongoose.model("Topic", TopicSchema);
const Bookmark = mongoose.model("Bookmark", BookmarkSchema);
const Keyword = mongoose.model("Keyword", KeywordSchema);
const Notice = mongoose.model("Notice", NoticeSchema);
const QA = mongoose.model("QA", QASchema);
const Request = mongoose.model("Request", RequestSchema);
const Word = mongoose.model("Word", WordSchema);

module.exports = {
    User,
    News,
    Bubble,
    Topic,
    Bookmark,
    Keyword,
    Notice,
    QA,
    Request,
    Word,
};