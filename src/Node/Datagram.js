'use strict';
var dgram = require('dgram')

// module Node.Datagram

exports._createSocket = function(socketType) {
  return function() {
    return dgram.createSocket(socketType)
  }
}

exports._closeSocket = function(socket) {
  return function() {
    socket.close()
    return {}
  }
}

exports._onMessage = function(callback) {
  return function(socket) {
    return function() {
      socket.on('message', function(buf, rinfo) {
        callback(buf)(rinfo)()
      })
      return {}
    }
  }
}

exports._onError = function(callback, socket) {
  return function() {
    socket.on('error', function(err) {
      callback(err)()
    })
    return {}
  }
}

exports._onClose = function(callback, socket) {
  return function() {
    socket.on('close', function() {
      callback()()
    })
    return {}
  }
}

exports._onListening = function(callback, socket) {
  return function() {
    socket.on('listening', function() {
      callback()()
    })
    return {}
  }
}

exports._bind = function(port, address, socket) {
  return function(success, error) {
    try {
      socket.bind(port.value0, address.value0, function() {
        success(socket.address())
      })
    } catch(e) {
      error(e)
    }
  }
}

exports.address = function(socket) {
  return function(success, error) {
    try {
      return socket.address()
    } catch (e) {
      error(e)
    }
  }
}

exports._send = function(buffer, offset, length, port, address, socket) {
  return function(success, error) {
    socket.send(buffer, offset, length, port, address, function(e) {
      if (e) {
        error(e)
      } else {
        success({})
      }
    })
  }
}

exports._ref = function(socket) {
  return function() {
    return socket.ref()
  }
}

exports._unref = function(socket) {
  return function() {
    return socket.unref()
  }
}

exports._setBroadcast = function(broadcast, socket) {
  return function() {
    socket.setBroadcast(broadcast)
    return socket
  }
}

exports._setTTL = function(hops, socket) {
  return function() {
    socket.setTTL(hops)
    return socket
  }
}

exports._setMulticastTTL = function(hops, socket) {
  return function() {
    socket.setMulticastTTL(hops)
    return socket
  }
}

exports._addMembership = function(address, maybeInterface, socket) {
  return function() {
    var interfaceVal = maybeInterface.value0 ? maybeInterface.value0 : undefined
    socket.addMembership(address, interfaceVal)
    return socket
  }
}

exports._dropMembership = function(address, maybeInterface, socket) {
  return function() {
    var interfaceVal = maybeInterface.value0 ? maybeInterface.value0 : undefined
    socket.dropMembership(address, interfaceVal)
    return socket
  }
}
