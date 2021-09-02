<template>
  <v-container>
    <v-row>
      <v-col>
        <v-btn tile color="indigo" class="float-right" link :to="{name: 'purchase-list'}">
          {{ $t("Back") }}
        </v-btn>
      </v-col>
    </v-row>
    <v-row justify="center" class="">
      <v-col cols="12" sm="12" md="12">
        <v-card class="mb-70" flat>
          <v-card-title class="justify-center">
            {{ $t("view") }}
          </v-card-title>
          <v-card-text>
            <v-row>
              <v-col cols="12" sm="12" md="12">
                <v-row>
                  <v-col cols="12" sm="4" md="4">
                    <b>{{ $t("supplier_name") }} : </b>
                    <span>{{ purchase.supplier_name }}</span>
                  </v-col>
                  <v-col cols="12" sm="4" md="4">
                    <b>{{ $t("purchase_no") }} : </b>
                    <span>{{ purchase.purchase_number }}</span>
                  </v-col>
                  <v-col cols="12" sm="4" md="4">
                    <b>{{ $t("purchase_status") }} : </b>
                    <span>{{ purchase.purchase_status }}</span>
                  </v-col>
                  <v-col cols="12" sm="4" md="4">
                    <b>{{ $t("date") }} : </b>
                    <span>{{ purchase.purchase_date }}</span>
                  </v-col>
                  <v-col cols="12" sm="4" md="4">
                    <b>{{ $t("total_amount") }} : </b>
                    <span>{{ purchase.total_cost }}</span>
                  </v-col>
                  <v-col cols="12" sm="4" md="4">
                    <b>{{ $t("date") }} : </b>
                    <span>{{ purchase.purchase_date }}</span>
                  </v-col>
                </v-row>
              </v-col>
            </v-row>
            <v-row class="mt-2">
              <v-col cols="12" sm="12" md="12">
                <h3 class="text-center">{{ $t("purchase_items") }}</h3>
                <v-data-table
                  flat
                  :headers="headers"
                  :items="purchaseItems"
                  hide-default-footer
                  class="elevation-1 pb-4 mt-2"
                ></v-data-table>

              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  middleware: "auth",
  head: {
    title: "Purchase Detail",
  },
  data: () => ({
    isLoading: false,
    reveal: false,
    statuses: ["Active", "Inactive"],
    error: null,
    direction: "top right",
    purchase: [],
    purchaseItems: [],

  }),
  computed: {
    headers() {
      return [
        {
          sortable: false,
          text: this.$t("name"),
          value: "name"
        },
        {
          sortable: false,
          text: this.$t("quantity"),
          value: "purchase_quantity"
        },
        {
          sortable: false,
          text: this.$t("price"),
          value: "price"
        },
        {
          sortable: false,
          text: this.$t("sub_total"),
          value: "subtotal"
        },

      ];
    },
    parsedDirection() {
      return this.direction.split(" ");
    },
  },

  async asyncData({params, $axios}) {
    const {data} = await $axios.get(`purchase/${params.id}`);
    return {
      purchase: data.data,
      purchaseItems: data.data.items,
    };
  },
  created() {
  },
  methods: {},
};
</script>

<style scoped>

</style>
