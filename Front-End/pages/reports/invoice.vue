<template>
  <v-container>
    <invoice-report/>
  </v-container>
</template>

<script>

import invoiceReport from "~/components/reports/invoiceReport";
export default {
  name: "purchase",
  middleware: "auth",
  head: {
    title: "Purchase Report",
  },
  components: {invoiceReport},
  data() {
    return {};
  },
  computed: {},
  async asyncData({ params, axios }) {},
  mounted() {},
  methods: {},
};
</script>

<style lang="scss" scoped>
</style>
