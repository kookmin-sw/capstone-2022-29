const router = require("express").Router();
const controller = require("./controllers");

// user
router.post("/users", controller.postUserInfo);
router.get("/users", controller.getUserInfo);
router.get("/users/find", controller.findUser);
router.put("/users", controller.updateUser);

// news
router.post("/news", controller.postNews);
router.get("/news", controller.getNews);

// bubble
router.post("/bubbles", controller.postBubble);
router.get("/bubbles", controller.getBubble);

// topic


// bookmark
router.post("/bookmarks", controller.postBookmark);
router.get("/bookmarks", controller.getBookmark);
router.put("/bookmarks", controller.updateBookmark);

module.exports = router;