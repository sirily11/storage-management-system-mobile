import JSONSchemaTextField from "../components/edit/JSONSchema/Components/JSONSchemaTextField"
import React from 'react'
import {render, fireEvent} from '@testing-library/react'

describe("", () => {
    it("Test parsing text field", async () => {
        let s = {
            "label": "Item Name",
            "readonly": false,
            "extra": {
                "help": "Please Enter your item name",
                "default": ""
            },
            "name": "name",
            "widget": "text",
            "required": false,
            "translated": false,
            "validations": {
                "length": {
                    "maximum": 1024
                }
            }
        }

    })
})