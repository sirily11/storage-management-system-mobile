import { getAllLocalPosts, insertPost } from "../components/model/utils/localDB";
import { Post } from '../components/home/HomePage';
import { setTimeout } from "timers";

describe("Test local db", () => {
    const userID = 1;
    const post: Post = {
        title: "Test post",
        content: "Lol",
        isLocal: true
    }


    test("Get posts", async () => {
        let posts = await getAllLocalPosts(userID);
        expect(posts.length).toBe(0)
    })

    test("Insert", async () => {
        await insertPost(userID, post);
        let posts = await getAllLocalPosts(userID);
        expect(posts.length).toBe(1)
    })


})