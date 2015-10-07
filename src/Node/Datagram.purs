module Node.Datagram(
    Socket(),
    SOCKET(),
    SocketType(..),
    Port(),
    Address(),
    Family(),
    BufferLength(),
    Interface(),
    SocketInfo(),
    RemoteAddressInfo(),
    createSocket,
    closeSocket,
    bindSocket,
    address,
    onMessage,
    onError,
    send,
    ref,
    unref,
    setBroadcast,
    setTTL,
    setMulticastTTL,
    addMembership,
    dropMembership    
) where

import Control.Monad.Aff
import Control.Monad.Eff
import Control.Monad.Eff.Class
import Control.Monad.Eff.Exception (Error())
import Node.Buffer
import Prelude
import Data.Maybe
import Data.Function

foreign import data Socket :: *
foreign import data SOCKET :: !

data SocketType = UDP4 | UDP6

type Port = Int
type Address = String
type Family = String
type BufferLength = Int
type Interface = String

newtype SocketInfo = SocketInfo {
    port :: Port,
    address :: Address,
    family :: Family
}

newtype RemoteAddressInfo = RemoteAddressInfo {
    address :: Address,
    port :: Port
}

instance showSocketType :: Show SocketType where
    show UDP4 = "udp4"
    show UDP6 = "udp6"

instance showSocketInfo :: Show SocketInfo where
    show (SocketInfo { port: p, address: a, family: f }) = "port: " ++ show p ++ " address: " ++ show a ++ " family: " ++ show f

instance showRemoteAddressInfo :: Show RemoteAddressInfo where
    show (RemoteAddressInfo { address: a, port: p }) = "address: " ++ show a ++ " port: " ++ show p

createSocket :: forall eff. SocketType -> Aff (socket :: SOCKET | eff) Socket
createSocket socketType = liftEff <<< _createSocket $ show socketType

closeSocket :: forall eff. Socket -> Aff (socket :: SOCKET | eff) Unit
closeSocket = liftEff <<< _closeSocket

bindSocket :: forall eff. Maybe Port -> Maybe Address -> Socket -> Aff (socket :: SOCKET | eff) SocketInfo
bindSocket = runFn3 _bind 

onMessage :: forall eff. (Buffer -> RemoteAddressInfo -> Eff eff Unit) -> Socket -> Aff (socket :: SOCKET | eff) Unit
onMessage msgHandler socket = liftEff $ _onMessage msgHandler socket

onError :: forall eff. (Error -> Eff eff Unit) -> Socket -> Aff (socket :: SOCKET | eff) Unit
onError errHandler socket = liftEff $ runFn2 _onError errHandler socket

send :: forall eff. Buffer -> Offset -> BufferLength -> Port -> Address -> Socket -> Aff (socket :: SOCKET | eff) Unit
send = runFn6 _send

ref :: forall eff. Socket -> Aff (socket :: SOCKET | eff) Socket
ref = liftEff <<< _ref

unref :: forall eff. Socket -> Aff (socket :: SOCKET | eff) Socket
unref = liftEff <<< _unref

setBroadcast :: forall eff. Boolean -> Socket -> Aff (socket :: SOCKET | eff) Socket
setBroadcast multicast socket = liftEff $ runFn2 _setBroadcast multicast socket

setTTL :: forall eff. Int -> Socket -> Aff (socket :: SOCKET | eff) Socket
setTTL hops socket = liftEff $ runFn2 _setTTL hops socket

setMulticastTTL :: forall eff. Int -> Socket -> Aff (socket :: SOCKET | eff) Socket
setMulticastTTL hops socket = liftEff $ runFn2 _setMulticastTTL hops socket

addMembership :: forall eff. Address -> (Maybe Interface) -> Socket -> Aff (socket :: SOCKET | eff) Socket
addMembership addr interface socket = liftEff $ runFn3 _addMembership addr interface socket

dropMembership :: forall eff. Address -> (Maybe Interface) -> Socket -> Aff (socket :: SOCKET | eff) Socket
dropMembership addr interface socket = liftEff $ runFn3 _dropMembership addr interface socket

foreign import _createSocket :: forall eff. String -> Eff (socket :: SOCKET | eff) Socket
foreign import _bind :: forall eff. Fn3 (Maybe Int) (Maybe String) Socket (Aff (socket :: SOCKET | eff) SocketInfo)
foreign import address :: forall eff. Socket -> Aff (socket :: SOCKET | eff) SocketInfo
foreign import _closeSocket :: forall eff. Socket -> Eff (socket :: SOCKET | eff) Unit
foreign import _onMessage :: forall eff. (Buffer -> RemoteAddressInfo -> Eff eff Unit) -> Socket -> Eff (socket :: SOCKET | eff) Unit
foreign import _onError :: forall eff. Fn2 (Error -> Eff eff Unit) Socket (Eff (socket :: SOCKET | eff) Unit)
foreign import _send :: forall eff. Fn6 Buffer Int Int Int String Socket (Aff (socket :: SOCKET | eff) Unit)
foreign import _ref :: forall eff. Socket -> Eff (socket :: SOCKET | eff) Socket
foreign import _unref :: forall eff. Socket -> Eff (socket :: SOCKET | eff) Socket
foreign import _setBroadcast :: forall eff. Fn2 Boolean Socket (Eff (socket :: SOCKET | eff) Socket)
foreign import _setTTL :: forall eff. Fn2 Int Socket (Eff (socket :: SOCKET | eff) Socket)
foreign import _setMulticastTTL :: forall eff. Fn2 Int Socket (Eff (socket :: SOCKET | eff) Socket)
foreign import _addMembership :: forall eff. Fn3 String (Maybe String) Socket (Eff (socket :: SOCKET | eff) Socket)
foreign import _dropMembership :: forall eff. Fn3 String (Maybe String) Socket (Eff (socket :: SOCKET | eff) Socket)
