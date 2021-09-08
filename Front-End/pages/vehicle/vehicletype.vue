<template>
  <v-container fluid grid-list-sm class="mt-5">
    <v-row justify="center">
      <add-type @refresh="getTypes()"/>
      <edit-type :item="singleItem" @refresh="getTypes()"/>
      <v-dialog v-model="confirmation" max-width="300">
        <v-card>
          <v-card-title>
            {{ $t("are_you_sure") }}
            <v-spacer/>
            <v-icon aria-label="Close" @click="confirmation = false">
              mdi-close
            </v-icon>
          </v-card-title>
          <v-card-text class="pb-6 pt-12 text-center">
            <v-btn class="mr-3" text @click="confirmation = false"> {{ $t("no") }}</v-btn>
            <v-btn color="success" text @click="confirmDelete()"> {{ $t("yes") }}</v-btn>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-row>
    <v-row>
      <v-col>
        <v-btn
          tile
          color="indigo"
          class="float-right"
          @click="opendialog('add')"
        >
          <v-icon left> mdi-plus</v-icon>
          {{ $t("add") }}
        </v-btn>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" md="12">
        <v-card v-if="isLoading" flat>
          <v-skeleton-loader class="mx-auto" type="table"></v-skeleton-loader>
        </v-card>
        <v-card class="mb-70" v-else flat>
          <v-card-title>
            {{ $t("vehicle_type_list") }}
            <v-spacer></v-spacer>
            <v-text-field
              v-model="search"
              append-icon="mdi-magnify"
              label="Search"
              single-line
              hide-details
            ></v-text-field>
          </v-card-title>
          <v-card-text>
            <v-data-table :headers="headers" :items="items" :search="search">
              <template v-slot:item.actions="{ item }">
                <v-icon @click="editType(item)"> mdi-square-edit-outline</v-icon>
                <v-icon @click="deleteType(item)"> mdi-trash-can-outline</v-icon>
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import addType from "../../components/vehicle/addType.vue";
import editType from "../../components/vehicle/editType.vue";

export default {
  name: "vehicleType",
  middleware: "auth",
  head: {
    title: "Add Type",
  },
  components: {addType, editType},
  data() {
    return {
      search: "",
      isLoading: false,
      confirmation: false,
      update: false,
      headline: this.$t("Add Vehicle Type"),
      alert: false,
      message: "",
      dialog: false,
      catid: "",
      categories: [],
      items: [],
      singleItem: {},
    };
  },
  computed: {
    headers() {
      return [
        {
          sortable: false,
          text: this.$t("name"),
          value: "name",
        },
        {
          sortable: false,
          text: this.$t("description"),
          value: "description",
        },
        {
          sortable: false,
          text: this.$t("action"),
          value: "actions",
        },
      ];
    },
  },
  async asyncData({params, axios}) {
  },
  mounted() {
    this.getTypes();
  },
  methods: {
    opendialog(type) {
      this.$store.commit("SET_MODAL", {type: type, status: true});
    },
    async getTypes() {
      this.isLoading = true;
      await this.$axios.get("/vehicle-type").then((response) => {
        this.items = response.data;
        this.isLoading = false;
      });
    },
    deleteType(item) {
      this.confirmation = true;
      this.catid = item.id;
    },
    async confirmDelete() {
      await this.$axios.delete(`vehicle-type/${this.catid}`).then((res) => {
        let data = {alert: true, message: this.$t("delete_successful"), type: 'success'};
        this.$store.commit("SET_ALERT", data);
        this.$store.commit("SET_MODAL", false);
        this.confirmation = false;
        this.getTypes();
      });
    },
    editType(item) {
      this.$store.commit("SET_MODAL", {type: "edit", status: true});
      this.singleItem = item;
    },
  },
};
</script>

<style>
</style>
