import GenericDetailPage, { GenericProps } from "./GenericDetail";
import { Series } from "../../../home/storageItem";
import { seriesSchema } from "./uiForm";
import { CreateAndupdater } from "../../../settings/UpdateAndCreate";

export default class SeriesDetail extends GenericDetailPage<Series> {
  constructor(props: GenericProps<Series>) {
    super(props);
    this.formData = {
      name: "",
      description: "",
      id: -1
    };
    this.title = "系列";
    this.pathName = "series";
    this.createAndUpdater = new CreateAndupdater<Series>(this.pathName);
    this.schema = seriesSchema;
    this.state = {
      formData: this.formData,
      language: "Chinese"
    };
  }
}
