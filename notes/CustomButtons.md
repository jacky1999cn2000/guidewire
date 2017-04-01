# Custom Buttons

* **Scenario**:

  * We have a custom object called `Three_Pointer__c` with the following custom fields
    * Number (Auto Number)
    * Result__c (Picklist - `N/A`, `MADE`, `MISSED`)

* **Task** :

  * Create two Custom Buttons on Detailed Page, one to set `Result__c` to `MADE`, and the other to set `Result__c` to `MISSED`

  * Create two Custom Buttons on List Page, one to set all selected records' `Result__c` to `MADE`, and the other to set all selected records' `Result__c` to `MISSED`

* **Reference**
  [How To: Call Apex code from a Custom Button](https://andyinthecloud.com/2013/07/16/how-to-call-apex-code-from-a-custom-button/)
  * [VF page redirect to previous page](http://salesforce.stackexchange.com/questions/122238/vf-page-get-the-previous-page-url-to-redirect-back)

* **Solution** :
  * Classes
    * ThreePointerControllerExt.cls
    * ThreePointerListControllerExt.cls

  * Pages
    * ThreePointerMadeDetailedPage.page
    * ThreePointerMissedDetailedPage.page
    * ThreePointerMadeListPage.page
    * ThreePointerMissedListPage.page

  * Custom Buttons (defined in `Three_Pointer__c.object`)
    * 2 custom buttons on Detailed page called `Made` and `Missed` respectively
    * 2 custom buttons on List View called `Made All` and `Missed All` respectively

  * Custom Tab
    * Three_Pointer__c.tab

  * layout
    * For Detailed Page custom buttons, add them to `Three_Pointer__c-Three Pointer Layout.layout`
    ![4.png](/screenshots/4.png)
    * For List View custom buttons, add them to `List View`
    ![3.png](/screenshots/3.png)
      
  * Demo
      * ![1.gif](/screenshots/1.gif)
      * ![2.gif](/screenshots/2.gif)
