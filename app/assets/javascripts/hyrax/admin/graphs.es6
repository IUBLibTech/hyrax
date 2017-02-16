export default class {
    constructor(data) {
        this.userActivity(data.userActivity);
        this.repositoryGrowth(data.repositoryGrowth);
        this.objectStatus(data.repositoryObjects);

    }


      // Draws a bar chart of new user signups
      userActivity(data) {
          if (typeof data === "undefined")
              return
          Morris.Bar({
               element: 'user-activity',
               data: data,
               xkey: 'y',
               // TODO: when we add returning users:
               // ykeys: ['a', 'b'],
               // labels: ['New Users', 'Returning'],
               ykeys: ['a'],
               labels: ['New Users', 'Returning'],
               barColors: ['#33414E', '#3FBAE4'],
               gridTextSize: '10px',
               hideHover: true,
               resize: true,
               gridLineColor: '#E5E5E5'
           });
      }

    // Draws a donut chart of active/inactive objects
    objectStatus(data) {
        if (typeof data === "undefined")
            return
        Morris.Donut({
            element: 'dashboard-repository-objects',
            data: data,
            colors: ['#33414E', '#3FBAE4', '#FEA223'],
            gridTextSize: '9px',
            resize: true
        });
    }

    // Creates a line graph of collections and object in the last 90 days
    repositoryGrowth(data) {
        if (typeof data === "undefined")
            return
        Morris.Line({
           element: 'dashboard-growth',
           data: data,
           xkey: 'y',
           ykeys: ['a','b'],
           labels: ['Objects','Collections'],
           resize: true,
           hideHover: true,
           xLabels: 'day',
           gridTextSize: '10px',
           lineColors: ['#3FBAE4','#33414E'],
           gridLineColor: '#E5E5E5'
        });
    }
}
