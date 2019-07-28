import React, { Component } from "react";
import {
  Button,
  Header,
  Icon,
  Segment,
  Form,
  Input,
  Message,
  Dropdown,
  Select
} from "semantic-ui-react";
import { Collapse } from "@material-ui/core";

interface State {
  address: string;
  message?: string;
  header: string;
}

interface Props {}

const options = [
  {
    text: "https://",
    value: "https://"
  },
  {
    text: "http://",
    value: "http://"
  }
];

export default class SettingPage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      address: "",
      message: undefined,
      header: options[0].value
    };
  }

  componentWillMount() {
    let url = localStorage.getItem("address");
    if (url !== null) {
      let temp = new URL(url);
      let address = temp.host + temp.pathname;
      let header = temp.protocol + "//";
      this.setState({ address, header });
    }
  }

  render() {
    const { message, header, address } = this.state;
    return (
      <div className="h-100 d-flex w-100" style={{ width: "300px" }}>
        <div className="m-auto" style={{ width: "300px" }}>
          <Header icon>
            <Icon name="settings" color="blue" />
            请在此处设置后台服务器地址……
          </Header>
          <Form>
            <Input
              fluid
              defaultValue={address}
              label={
                <Dropdown
                  button
                  value={header}
                  options={options}
                  onChange={(e, { value }) => {
                    this.setState({
                      header: value as string,
                      message: undefined
                    });
                  }}
                />
              }
              action={
                <Button
                  color="blue"
                  icon="chevron down"
                  onClick={() => {
                    if (address !== "") {
                      this.setState({
                        message: "地址已经更新到"
                      });
                      localStorage.setItem("address", `${header}${address}`);
                    } else {
                      this.setState({
                        message: "地址不能为空"
                      });
                    }
                  }}
                />
              }
              placeholder="服务器地址..."
              onChange={(e, { value }) => {
                let address = value;
                this.setState({ address });
              }}
            />
          </Form>
          <Collapse in={message !== undefined}>
            <Message info className="mt-3 w-100">
              <Message.Header>{message}</Message.Header>
              <div>
                {header}
                {address}
              </div>
            </Message>
          </Collapse>
        </div>
      </div>
    );
  }
}
