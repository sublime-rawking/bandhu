export const SortingProvider = ({ key, prevOrderBy, prevOrder, data }) => {
   console.log(key, prevOrderBy, prevOrder, data);
   
    let orderBy = prevOrderBy;
    let order = prevOrder;

    if (orderBy !== key) {
        orderBy = key;
        order = "acs";
    }
    let sortedData = [];

    if (order === "decs") {
        order = "acs";

        sortedData = [...data].sort((a, b) => {
            if (a[key] < b[key]) {
                return -1;
            }
            if (a[key] > b[key]) {
                return 1;
            }
            return 0;
        });
    } else {
        order = "decs";
        sortedData = [...data].sort((a, b) => {
            if (a[key] > b[key]) {
                return -1;
            }
            if (a[key] < b[key]) {
                return 1;
            }
            return 0;
        });
    }

    return { sortedData, orderBy, order }
}