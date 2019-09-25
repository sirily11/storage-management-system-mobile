import JSONSchemaTextField from "../components/edit/JSONSchema/Components/JSONSchemaTextField";
import React from "react";
import {
  render,
  fireEvent,
  waitForDomChange,
  wait
} from "@testing-library/react";
import { JSONSchema } from "../components/edit/JSONSchema";

describe("When read only is true, no text field should be rendered", () => {
  it("Test parsing text field", async () => {
    let s = [
      {
        label: "Name",
        readonly: true,
        extra: {
          help: "Please Enter your item name",
          default: ""
        },
        name: "name",
        widget: "text",
        required: false,
        translated: false,
        validations: {
          length: {
            maximum: 1024
          }
        }
      },
      {
        label: "Item Description",
        readonly: false,
        extra: {
          help: "Please Enter your item name",
          default: ""
        },
        name: "description",
        widget: "text",
        required: false,
        translated: false,
        validations: {
          length: {
            maximum: 1024
          }
        }
      }
    ];

    const { queryByText } = render(
      <JSONSchema schemas={s} url="">
        {" "}
      </JSONSchema>
    );

    let textDescription = queryByText("Item Description");
    let textNameFiled = queryByText("Name");
    expect(textNameFiled).toBeNull();
    expect(textDescription).toBeDefined();
  });

  it("Test if number, text, select, forignkey will be rendered", async () => {
    let s = [
      {
        label: "Name",
        readonly: false,
        name: "name",
        widget: "number",
        required: false,
        translated: false,
        validations: {
          length: {
            maximum: 1024
          }
        }
      },
      {
        label: "Item Description",
        readonly: false,
        extra: {
          help: "Please Enter your item name",
          default: ""
        },
        name: "description",
        widget: "text",
        required: false,
        translated: false,
        validations: {
          length: {
            maximum: 1024
          }
        }
      },
      {
        label: "Item Selection",
        readonly: false,
        extra: {
          help: "Please Enter your item name",
          default: ""
        },
        name: "description",
        widget: "select",
        required: false,
        translated: false,
        validations: {
          length: {
            maximum: 1024
          }
        }
      },
      {
        label: "Item Forignkey",
        readonly: false,
        extra: {
          help: "Please Enter your item name",
          default: ""
        },
        name: "description",
        widget: "forignkey",
        required: false,
        translated: false,
        validations: {
          length: {
            maximum: 1024
          }
        }
      }
    ];

    const { queryByText } = render(
      <JSONSchema schemas={s} url="">
        {" "}
      </JSONSchema>
    );

    ["Item Forignkey", "Item Selection", "Item Description", "Name"].forEach(
      s => expect(queryByText(s)).toBeDefined()
    );
  });

  it("If some type is not one of the accepted widget type, nothing will be rendered", () => {
    let s = [
      {
        label: "tomany-table",
        readonly: false,
        name: "name",
        widget: "tomany-table",
        required: false,
        translated: false,
        validations: {
          length: {
            maximum: 1024
          }
        }
      },
      {
        label: "nothing-here-type",
        readonly: false,
        name: "name",
        widget: "nothing-here-type",
        required: false,
        translated: false,
        validations: {
          length: {
            maximum: 1024
          }
        }
      }
    ];
    const { queryByText } = render(
      <JSONSchema schemas={s} url="">
        {" "}
      </JSONSchema>
    );
    ["tomany-table", "nothing-here-type"].forEach(s =>
      expect(queryByText(s)).toBeNull()
    );
  });

  it("test textfield with default value", async () => {
    let s = {
      label: "Item Name",
      readonly: false,
      extra: {
        help: "Please Enter your item name"
      },
      name: "name",
      widget: "text",
      required: false,
      translated: false,
      validations: {
        length: {
          maximum: 1024
        }
      },
      value: "Some name"
    };
    const onchange = jest.fn();
    const { queryByText, queryByTestId } = render(
      <JSONSchemaTextField schema={s} onSaved={onchange}></JSONSchemaTextField>
    );

    let textfield = queryByTestId("input-field") as HTMLElement;
    expect(textfield).not.toBe(null);
    expect(queryByText("Item Name")).not.toBe(null);
    // helper text
    expect(queryByText("Please Enter your item name")).not.toBe(null);
    // type result
    expect((textfield.firstChild as HTMLInputElement).value).toBe("Some name");
  });
});
