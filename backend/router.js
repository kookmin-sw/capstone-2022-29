const router = require("express").Router();

// controllers
const user = require("./controllers/user");
const news = require("./controllers/news");
const bubble = require("./controllers/bubble");
const topic = require("./controllers/topic");
const bookmark = require("./controllers/bookmark");

// user
router.post("/users", user.postUserInfo);
router.get("/users", user.getUserInfo);
router.put("/users", user.updateUser);
router.get("/users", user.getAllUserInfo);

// news
router.post("/news", news.postNews);
router.get("/news", news.getNews);
router.get("/news", news.getAllNews);

// bubble
router.post("/bubbles", bubble.postBubble);
router.get("/bubbles", bubble.getBubble);
router.put("/bubbles", bubble.updateBubble);
router.get("/bubbles", bubble.getAllBubble);
router.get("/buubles", bubble.getBubbleQuery);
router.put("/buubles", bubble.updateBubbleCount);

// topic


// bookmark
router.post("/bookmarks", bookmark.postBookmark);
router.get("/bookmarks", bookmark.getBookmark);
router.put("/bookmarks", bookmark.updateBookmark);

module.exports = router;