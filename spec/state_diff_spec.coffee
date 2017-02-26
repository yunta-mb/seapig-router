seapig_client = new SeapigClient("ws://localhost:3001")
router = new SeapigRouter(seapig_client, debug: false, expose_privates: true)

check = (data)->
        diff = router.private.state_diff_generate(data.old_state, data.new_state)
        expect(diff).toEqual(data.correct_diff)
        patched = router.private.state_diff_apply(data.old_state, diff)
        expect(patched).toEqual(data.new_state)

describe "SeapigRouter", ->

        it "returns empty string for empty objects", ->
                check(old_state: {}, new_state: {}, correct_diff: [])

        describe "with basic values", ->

                it "can handle new basic value", ->
                        check(old_state: {}, new_state: {xxx: '1'}, correct_diff: [["xxx","1"]])

                it "can handle deleted basic value", ->
                        check(old_state: {xxx: '1'}, new_state: {}, correct_diff: [["-xxx","-"]])

                it "can handle changed basic value", ->
                        check(old_state: {xxx: '1'}, new_state: {xxx: '2'}, correct_diff: [["xxx","2"]])

                it "can handle unchanged basic value", ->
                        check(old_state: {xxx: '1'}, new_state: {xxx: '1'}, correct_diff: [])

                it "can handle all changes of basic value", ->
                        check(old_state: {removed: '1', changed: '1', unchanged: '1'}, new_state: {changed: '2', unchanged: '1', added: '1'}, correct_diff: [["-removed","-"],["changed","2"],["added","1"]])

        describe "with objects", ->

                it "can handle new filled object", ->
                        check(old_state: {}, new_state: {xxx: {yyy: '1'}}, correct_diff: [["xxx.yyy","1"]])

                it "can handle deleted object", ->
                        check(old_state: {xxx: {yyy: '1'}}, new_state: {}, correct_diff: [["-xxx","-"]])

                it "can handle emptied object", ->
                        check(old_state: {xxx: {yyy: '1'}}, new_state: {xxx: {}}, correct_diff: [["-xxx.yyy","-"]])

                it "can handle changed basic value in nested object", ->
                        check(old_state: {xxx: {yyy: '1'}}, new_state: {xxx: {yyy: '2'}}, correct_diff: [["xxx.yyy","2"]])

                it "can handle all changes of basic value in nested object", ->
                        check(old_state: {xxx: {removed: '1', changed: '1', unchanged: '1'}}, new_state: {xxx: {changed: '2', unchanged: '1', added: '1'}}, correct_diff: [["-xxx.removed","-"],["xxx.changed","2"],["xxx.added","1"]])

        describe "with arrays", ->

                it "can handle new basic value in new array", ->
                        check(old_state: {}, new_state: {xxx: ['1']}, correct_diff: [["xxx~~","1"]])

                it "can handle deleted basic value from array", ->
                        check(old_state: {xxx: ['1','2','3']}, new_state: {xxx: ['1','3']}, correct_diff: [["-xxx~~","2"]])

                it "can handle added basic value to end of array", ->
                        check(old_state: {xxx: ['1','2','3']}, new_state: {xxx: ['1','2','3','4']}, correct_diff: [["xxx~~","4"]])

                it "can handle added basic value in the middle of an array", ->
                        check(old_state: {xxx: ['1','2','3','4']}, new_state: {xxx: ['1','2','5','3','4']}, correct_diff: [["xxx~2~","5"]])

                it "can handle added multiple basic values in the middle of an array", ->
                        check(old_state: {xxx: ['1','2','3','4']}, new_state: {xxx: ['1','2','5','6','3','4']}, correct_diff: [["xxx~2~","5"],["xxx~3~","6"]])

                it "can handle multiple additions and removals", ->
                        check(old_state: {xxx: ['1','2','3','4','5']}, new_state: {xxx: ['1','2','6','7','4','5','8']}, correct_diff: [["-xxx~~","3"],["xxx~2~","6"],["xxx~3~","7"],["xxx~~","8"]])

                it "can handle changed hash within array", ->
                        check(old_state: {xxx: [{yy: '1'}]}, new_state: {xxx: [{yy: '2'}]}, correct_diff: [["-xxx~0~","-"],["xxx~~.yy","2"]])
