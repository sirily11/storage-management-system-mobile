import React, { Component } from "react";
import {
  Paper,
  CardContent,
  Slide,
  Fade,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  Divider
} from "@material-ui/core";
import { DetailStorageItem, unitOptions } from "../home/storageItem";
import { CardHeader, Button, Icon, Dropdown } from "semantic-ui-react";
import { getCurrencyRate, convertCurrency } from "../settings/utils";

interface Props {
  item?: DetailStorageItem;
}

interface State {
  showDetail: boolean;
  items: DetailStorageItem[];
  currencyRate?: Map<string, number>;
  total: number;
  unit: string;
}

export default class CheckoutPage extends Component<Props, State> {
  el: any;

  constructor(props: Props) {
    super(props);
    this.state = {
      showDetail: false,
      items: [],
      total: 0,
      unit: unitOptions[0].value
    };
  }

  async componentDidMount() {
    setTimeout(async () => {
      let rate = await getCurrencyRate();
      this.setState({ currencyRate: rate });
    }, 300);
  }

  componentDidUpdate(prev: Props) {
    if (
      this.props.item !== undefined &&
      this.props.item !== prev.item &&
      this.state.showDetail
    ) {
      let { items, unit, currencyRate, total } = this.state;

      let uuids = items.map(i => i.uuid);
      if (!uuids.includes(this.props.item.uuid) && currencyRate) {
        let item = this.props.item;
        items.push(item);
        this.setState({ items: items });
        setTimeout(() => {
          let l = document.getElementById("item-list");
          if (l !== null) {
            l.scrollTop = l.scrollHeight;
          }
        }, 30);
      }
    }
  }

  toggle = () => {
    const { showDetail } = this.state;
    this.setState({ showDetail: !showDetail });
  };

  remove = (index: number) => {
    const { unit, currencyRate, total } = this.state;
    let items = this.state.items;
    items.splice(index, 1);
    this.setState({ items: items });
  };

  calculateTotal(items: DetailStorageItem[]): number {
    let total = 0;
    const { unit, currencyRate } = this.state;
    for (let i of items) {
      let newPrice = convertCurrency(i.price, i.unit, unit, currencyRate);
      total += newPrice;
    }
    return total;
  }

  render() {
    const { showDetail, items, total, unit } = this.state;
    return (
      <div>
        {
          <Fade in={!showDetail}>
            <Button
              color="google plus"
              style={{
                position: "fixed",
                right: "30px",
                bottom: "30px",
                zIndex: 300
              }}
              onClick={this.toggle}
            >
              <Icon name="shopping cart" />
              购物车结账
            </Button>
          </Fade>
        }
        <Slide direction="up" in={showDetail}>
          <Paper
            square
            elevation={20}
            style={{
              width: "400px",
              position: "fixed",
              right: "20px",
              bottom: "0",
              zIndex: 300
            }}
          >
            <CardContent>
              <CardHeader>
                <h3>
                  Items <Button icon="close" onClick={this.toggle} />
                  <Dropdown
                    placeholder="unit"
                    options={unitOptions}
                    value={unit}
                    onChange={(e, { value }) => {
                      this.setState({ unit: value as string });
                    }}
                  />
                </h3>
              </CardHeader>
              <List
                style={{ maxHeight: "300px", overflowY: "auto" }}
                id="item-list"
              >
                {items &&
                  items.map((i, index) => (
                    <ListItem key={`cart-${index}`}>
                      <ListItemText
                        primary={i.name}
                        secondary={`${i.price}${i.unit}`}
                      />
                      <ListItemSecondaryAction>
                        <Button
                          icon="trash"
                          onClick={() => {
                            this.remove(index);
                          }}
                        />
                      </ListItemSecondaryAction>
                    </ListItem>
                  ))}
              </List>
              <Divider />
              <h4>
                总额: {Math.abs(this.calculateTotal(items)).toFixed(3)} {unit}
              </h4>
            </CardContent>
          </Paper>
        </Slide>
      </div>
    );
  }
}
