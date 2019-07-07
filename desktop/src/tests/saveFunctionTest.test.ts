import { markdownToDraft, draftToMarkdown } from "../components/editor/plugin/markdown-draft-js"
import { RawDraftContentState } from "draft-js";

describe("Parsing test", () => {
    let markdown = `（2016年6月18日）从深圳坐火车到昆明，一路途经大理最终抵达丽江。这便是这次行程的完整路线。没有详细的计划，只苛求能够细细品味栖息于这崇山峻岭间的每一分每一秒.\n

    ![](https://sirilee-webpage-post-image.s3.ap-east-1.amazonaws.com/postImage/Screen_Shot_2019-06-22_at_8.48.24_AM.png)\n
   
    ![](https://static.sirileepage.com/static/markdownx/43e04f41-d2d3-4271-9a7e-a0b8569bbde6.JPG)`

    test("Parsing", () => {
        let raw: RawDraftContentState = markdownToDraft(markdown)
        expect(raw.blocks.length).toBe(3)
    })


})
