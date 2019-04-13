let ESX;
let carBlip;
let intr = setInterval(function(){
    if(!ESX){
        TriggerEvent('esx:getSharedObject', obj => ESX = obj);
    } else {
        clearInterval(intr);
    }
}, 15)
onNet('bingo_bags:requestfocus', () => {
    SetNuiFocus(true, true);
})
onNet('bingo_core:startLooking', plate => {
    emit('currentvehicle:startLooking', [{plate: plate}]);
});

on('currentvehicle:startLooking', vehicleList => {
    console.log('currentVehicle.js: börjar kolla i billistan');
    let res = ESX.Game.GetClosestVehicle();
    let veh = res[0], distance = res[1];

    console.log('Result was: ')
    console.log(veh);
    console.log(distance);

    if(veh == -1 || distance > 5 ){
        console.log('No vehicles nearby.');
    } else {
        let tempList = vehicleList.map(x => x.plate);
        let plate = GetVehicleNumberPlateText(veh).replace(' ', '').replace(' ', '');
        if(tempList.find(x => x === plate)){

            console.log('en bil hittades!');

            let data = {
                updateCurrentVehicle: true,
                vehicleData: {
                    vehicle: veh,
                    plate: plate,
                    lock: GetVehicleDoorLockStatus(veh),
                    health: GetVehicleBodyHealth(veh),
                    engineOn: IsVehicleEngineOn(veh),
                    engineHealth: GetVehicleEngineHealth(veh),
                    fuel: GetVehicleFuelLevel(veh),
                    tankHealth: GetVehiclePetrolTankHealth(veh),
                    headlights: {
                        left: IsHeadlightLBroken(veh),
                        right: IsHeadlightRBroken(veh)
                    }
                }
            }
            console.log('Found. Sending data to app.');
            emit('bingo_core:phone:sendnui', data);
        } else {
            console.log('Templist does not contain your plate.');
            console.log('Templist contains ' + JSON.stringify(tempList));
            console.log(tempList);
            console.log('Plate is: "' + plate + '"');
        }
    }
});

on('currentvehicle:setEngine', (veh, val) => {
    SetVehicleEngineOn(veh, val, true, true); // TODO: Make sure this shit works as expected. Try changing val to BOOL. Currently 1 / 0
})

on('currentVehicle:showOnMap', veh => {
    if(carBlip){
        RemoveBlip(carBlip);
    }
    carBlip = AddBlipForEntity(veh);

    SetBlipSprite(carBlip, 326);
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Din bil")
    EndTextCommandSetBlipName(carBlip)
    SetBlipColour(carBlip, 17);
    console.log('Showing car on map.');
});

on('currentVehicle:hideOnMap', () => {
    if(carBlip){
        RemoveBlip(carBlip);
    }
})


on('currentvehicle:setLock', (veh, lock) => {
    SetVehicleDoorsLockedForAllPlayers(veh, lock);
});

on('currentvehicle:testHonk', veh => {
    StartVehicleHorn(veh, 1400, 'HELDDOWN')
});

onNet('currentvehicle:updateFromServer', veh => {
    emit('currentvehicle:update', veh);
})

on('currentvehicle:update', veh => {
    console.log('Updating current vehicle from app.');
    let data = {
        updateCurrentVehicle: true,
        vehicleData: {
            vehicle: veh,
            plate: GetVehicleNumberPlateText(veh),
            lock: GetVehicleDoorLockStatus(veh),
            health: GetVehicleBodyHealth(veh),
            engineOn: IsVehicleEngineOn(veh),
            engineHealth: GetVehicleEngineHealth(veh),
            fuel: GetVehicleFuelLevel(veh),
            tankHealth: GetVehiclePetrolTankHealth(veh),
            headlights: {
                left: IsHeadlightLBroken(veh),
                right: IsHeadlightRBroken(veh)
            }
        }
    }
    emit('bingo_core:phone:sendnui', data);
})
