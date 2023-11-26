'use strict'
const fs = require('fs')
const log = require('./logger')
const mqtt = require('mqtt')
const date = require('date-and-time')
const HOST_NAME = process.env.HOST_NAME || 'myhost'
const MQTT_HOST = process.env.MQTT_HOST || 'mqtt-broker'
const MQTT_PORT = process.env.MQTT_PORT || '1883'
const MQTT_USER = process.env.MQTT_USER || 'hassio'
const MQTT_PASS = process.env.MQTT_PASS || 'hassio'
let syncTimeOut

const connectUrl = `mqtt://${MQTT_HOST}:${MQTT_PORT}`

const ReadFile = async()=>{
  try{
    let data = await fs.readFileSync('/data/hostInfo.json')
    if(data) return JSON.parse(data)
  }catch(e){
    throw(e);
  }
}

const client = mqtt.connect(connectUrl, {
  clientId: `mqtt_${HOST_NAME}`,
  clean: true,
  keepalive: 60,
  connectTimeout: 4000,
  username: MQTT_USER,
  password: MQTT_PASS,
  reconnectPeriod: 1000,
})
client.on('connect', ()=>{
  log.info('MQTT Connection successful...')
  startUpdate()
})

// The signals we want to handle
// NOTE: although it is tempting, the SIGKILL signal (9) cannot be intercepted and handled
var signals = {
  'SIGHUP': 1,
  'SIGINT': 2,
  'SIGTERM': 15
};
// Do any necessary shutdown logic for our application here
const shutdown = async() => {
  await clearTimeout(syncTimeOut)
  await sendAlwaysAvailableMessage('Offline')
  await sendDeviceAvailability('Offline')
  process.exit(128 + value);
};
// Create a listener for each of the signals that we want to handle
Object.keys(signals).forEach((signal) => {
  process.on(signal, () => {
    log.info(`process received a ${signal} signal`);
    shutdown();
  });
});
const startUpdate = async()=>{
  try{
    await registerSensors()
    updateSensors()
  }catch(e){
    log.error(e)
    setTimeout(startUpdate, 5000)
  }
}
const sendAlwaysAvailableMessage = (value)=>{
  return new Promise((resolve, reject)=>{
    client.publish(`homeassistant/sensor/sensible-${HOST_NAME}/always-available`, value, { qos: 1, retain: false }, (error)=>{
      if(error){
        reject(error)
      }
      resolve()
    })
  })
}
const sendDeviceAvailability = (value)=>{
  return new Promise((resolve, reject)=>{
    client.publish(`homeassistant/sensor/sensible-${HOST_NAME}/availability`, value, { qos: 1, retain: false }, (error)=>{
      if(error){
        reject(error)
      }
      resolve()
    })
  })
}
const updateSensor = (id, value)=>{
  return new Promise((resolve, reject)=>{
    client.publish(`homeassistant/sensor/sensible-${HOST_NAME}/sensible-${HOST_NAME}_${id}/state`, value, { qos: 1, retain: false }, (error)=>{
      if(error){
        reject(error)
      }
      resolve()
    })
  })
}
const updateSensors = async()=>{
  try{
    let hostInfo = await ReadFile()
    if(hostInfo?.length > 0){
      await sendAlwaysAvailableMessage('Online')
      await sendDeviceAvailability('Online')
      for(let i in hostInfo){
        await updateSensor(hostInfo[i].id, hostInfo[i].value)
      }
      let current_time = new Date()
      await updateSensor('system_time', date.format(current_time, 'YYYY-MM-DD HH:mm:ss'))
    }
    syncTimeOut = setTimeout(updateSensors, 5000)
  }catch(e){
    console.error(e);
    syncTimeOut = setTimeout(updateSensors, 5000)
  }
}
const registerHeartBeat = ()=>{
  return new Promise((resolve, reject)=>{
    let payload = {
      name: 'Heartbeat',
      icon: 'mdi:wrench-check',
      state_topic: `homeassistant/sensor/sensible-${HOST_NAME}/availability`,
      availability_topic: `homeassistant/sensor/sensible-${HOST_NAME}/always-available`,
      payload_available: 'Online',
      payload_not_available: 'Offline',
      unique_id: `sensible-${HOST_NAME}_heartbeat`,
      device: {
        identifiers: [`sensible-${HOST_NAME}`],
        manufacturer: 'Scuba',
        model: "Sensible-Sensor",
        name: `sensible-${HOST_NAME}`
      }
    }
    client.publish(`homeassistant/sensor/sensible-${HOST_NAME}/sensible-${HOST_NAME}_heartbeat/config`, JSON.stringify(payload), { qos: 1, retain: true }, (error)=>{
      if(error){
        reject(error)
      }
      resolve()
    })
  })
}
const registerSystemTime = ()=>{
  return new Promise((resolve, reject)=>{
    let payload = {
      name: 'System Time',
      icon: 'mdi:clock',
      state_topic: `homeassistant/sensor/sensible-${HOST_NAME}/sensible-${HOST_NAME}_system_time/state`,
      availability_topic: `homeassistant/sensor/sensible-${HOST_NAME}/availability`,
      payload_available: 'Online',
      payload_not_available: 'Offline',
      unique_id: `sensible-${HOST_NAME}_system_time`,
      device: {
        identifiers: [`sensible-${HOST_NAME}`],
        manufacturer: 'Scuba',
        model: "Sensible-Sensor",
        name: `sensible-${HOST_NAME}`
      }
    }
    client.publish(`homeassistant/sensor/sensible-${HOST_NAME}/sensible-${HOST_NAME}_system_time/config`, JSON.stringify(payload), { qos: 1, retain: true }, (error)=>{
      if(error){
        reject(error)
      }
      resolve()
    })
  })
}
const registerSensor = (id, name, icon, unit)=>{
  return new Promise((resolve, reject)=>{
    let payload = {
      name: name,
      icon: icon,
      state_topic: `homeassistant/sensor/sensible-${HOST_NAME}/sensible-${HOST_NAME}_${id}/state`,
      availability_topic: `homeassistant/sensor/sensible-${HOST_NAME}/availability`,
      payload_available: 'Online',
      payload_not_available: 'Offline',
      unique_id: `sensible-${HOST_NAME}_${id}`,
      device: {
        identifiers: [`sensible-${HOST_NAME}`],
        manufacturer: 'Scuba',
        model: "Sensible-Sensor",
        name: `sensible-${HOST_NAME}`
      }
    }
    if(unit) payload.unit_of_measurement = unit
    client.publish(`homeassistant/sensor/sensible-${HOST_NAME}/sensible-${HOST_NAME}_${id}/config`, JSON.stringify(payload), { qos: 1, retain: true }, (error)=>{
      if(error){
        reject(error)
      }
      resolve()
    })
  })
}
const registerSensors = async()=>{
  try{
    let hostInfo = await ReadFile()
    if(hostInfo?.length > 0){
      await registerHeartBeat()
      for(let i in hostInfo){
        await registerSensor(hostInfo[i].id, hostInfo[i].name, hostInfo[i].icon, hostInfo[i].unit)
      }
    }else{
      throw('Error reading hostInfo.json...')
    }
  }catch(e){
    throw(e)
  }
}
