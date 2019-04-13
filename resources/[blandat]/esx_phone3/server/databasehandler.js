onNet('esx_phone:save_settings', (data) => {
    let identifier = data.identifier, sql;
    if(!data.settings){
        sql = `DELETE FROM phonesettings WHERE identifier='${identifier}'`;
    } else {
        sql = `REPLACE INTO phonesettings (identifier, settings) VALUES ('${identifier}', '${JSON.stringify(data.settings)}')`;
    }

    emit('bingo_newcore:update', sql, res => {
        console.log('Saved phone settings.');
    });
});

onNet('esx_phone:load_settings', identifier => {
	console.log('Loading settings backend for ID: ' + identifier);
    let _source = source;
    let sql = `SELECT settings FROM phonesettings WHERE identifier='${identifier}'`;
	console.log('Query: ', sql);
    emit('bingo_newcore:query', sql, res => {
		console.log('Res is: ', res);
        if(res.length){
            console.log('res is:', res[0]);
            let settings = JSON.parse(res[0].settings);
            console.log('Loaded phone settings.');

            emitNet('esx_phone:load_settings', _source, settings);
        }
    });
});

onNet('esx_phone:reset_phone', data => {
    emit(`bingo_newcore:update', 'DELTE FROM user_contacts WHERE identifier='${data.identifier}'`, res => {
        console.log('Removed all contacts for ID: ', data.identifier);
    });
})
