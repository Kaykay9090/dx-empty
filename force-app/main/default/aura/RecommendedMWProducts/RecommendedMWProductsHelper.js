({
  selectedProducts: [],
  COLUMNS: [
    { label: "Product Id", fieldName: "ProductId", sortable: true, initialWidth: 200 },
    { label: "Plan Name", fieldName: "PlanName", sortable: true, initialWidth: 200 },
    { label: "Provider Name", fieldName: "ProviderName", sortable: true, initialWidth: 200 },
    {
      label: "Initial Monthly Payment",
      fieldName: "InitialMonthlyPayment",
      sortable: true,
      initialWidth: 200
    },
    {
      label: "Initial Interest Rate",
      fieldName: "InitialInterestRate",
      sortable: true, initialWidth: 200
    },
    { label: "APR", fieldName: "APR", sortable: true, initialWidth: 200 },
    {
      label: "Follow On Monthly Payment",
      fieldName: "FollowOnMonthlyPayment",
      sortable: true, initialWidth: 200,
    },
    {
      label: "Initial Interest Period",
      fieldName: "InitialInterestPeriod",
      sortable: true, initialWidth: 200
    },
    { label: "Loan Required", fieldName: "LoanRequired", sortable: true, initialWidth: 200 },
    {
      label: "Provider Variable Rate",
      fieldName: "ProviderVariableRate",
      sortable: true, initialWidth: 200
    },
    { label: "Disclosure", fieldName: "Disclosure", sortable: true, initialWidth: 200 },
  ],

  setColumns: function (cmp) {
    cmp.set("v.columns", this.COLUMNS);
  },

  setData: function (cmp, data) {
    cmp.set("v.data", data);
  },

  setSelectedProducts: function (cmp, selectedProducts) {
    this.selectedProducts = selectedProducts;
  },

  sortBy: function (field, reverse, primer) {
    var key = primer
      ? function (x) {
          return primer(x[field]);
        }
      : function (x) {
          return x[field];
        };

    return function (a, b) {
      a = key(a);
      b = key(b);
      return reverse * ((a > b) - (b > a));
    };
  },

  handleSort: function (cmp, event) {
    var sortedBy = event.getParam("fieldName");
    var sortDirection = event.getParam("sortDirection");

    var cloneData = this.DATA.slice(0);
    cloneData.sort(this.sortBy(sortedBy, sortDirection === "asc" ? 1 : -1));

    cmp.set("v.data", cloneData);
    cmp.set("v.sortDirection", sortDirection);
    cmp.set("v.sortedBy", sortedBy);
  },
});