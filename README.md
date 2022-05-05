# r14-rx
A simple prescription pad item for qb-core.

This resource IS NOT drag and drop, it requires to edits to your qb-core and qb-inventory resources to work properly. If you
are not familiar with lua, please consult a dev before making any changes to your server, and as always make a BACKUP of EVERY
file you are editing so that you can revert to a working version if needed.

This resource creates a job-locked prescription pad item that EMS workers can use to create prescriptions with, these items can be
carried in a user inventory and display the information to anyone who views the item. An EMS worker can use the item to tick off a
refill and then return the item to the patient. When all refills are ticked off, the item is no longer usable, but is not deleted.

----------- install guide --------------

1) You will need to add the following code to your qb-core/shared/items.lua, this will allow them the prescription pad and  
prescription item to be used as items by your inventory script. Add the following lines of code somewhere in the QBShared.Items
lua.

------------- code to be added for qb-core/shared/items.lua  ----------------

    ['prescriptionpad']              = {['name'] = 'prescriptionpad',               ['label'] = 'Prescription Pad',			['weight'] = 300,		['type'] = 'item',		['image'] = 'notepad.png',				['unique'] = true,		['useable'] = true,		['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A prescription pad with some unidentifiable scribbles on it'},
    ['prescription']			     = {['name'] = 'prescription',		            ['label'] = 'Prescription',				['weight'] = 300,		['type'] = 'item',		['image'] = 'prescription.png',			['unique'] = true,		['useable'] = true,		['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A piece of paper with some unidentifiable scribbles on it'},

------------- end of code ---------------------

2) You will need to add the following code to your qb-inventory/html/js/app.js to your FormatItemInfo() function, this allows the
items to have unique information displayed in the inventory system, and thus allow players to actually use the prescription items
for their intended purpose. After you add the code below, drop the images in the base of this repo into your qb-inventory/html/images
so they have images in your inventory. This code should also work with lj-inventory and tnj-inventory as it shares the same general 
format for its app.js file. If you are not familiar with js like I am, just find a semicolon line, create a break, and insert this
code.

------------- code to be added to qb-inventry/html/js/app.js near line 407 ----------------

        } else if (itemData.name == "prescriptionpad") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>Prescribing Physician: </strong><span>" +
                itemData.info.doctor +
                "</span></p><p><strong>Pages Torn Out: </strong><span>" +
                itemData.info.written +
                "</span></p><p><strong>Pad Issued: </strong><span>" +
                itemData.info.dateissued +
                "</p>"
            );
        } else if (itemData.name == "prescription") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>Prescribing Physician: </strong><span>" +
                itemData.info.doctor +
                "</span></p><p><strong>Date: </strong><span>" +
                itemData.info.date +
                "</span></p><p><strong>Patient Name: </strong><span>" +
                itemData.info.patient +
                "</span></p><p><strong>Refills: </strong><span>" +
                itemData.info.refills +
                "</span></p><p><strong>Refilled: </strong><span>" +
                itemData.info.refilled +
                "</span></p><p><strong>RX: </strong><span>" +
                itemData.info.rx +
                "</span></p><p><strong>Directions: </strong><span>" +
                itemData.info.directions +
                "</p>"
            );
            
------------- end of code ---------------------

3) Enjoy.
