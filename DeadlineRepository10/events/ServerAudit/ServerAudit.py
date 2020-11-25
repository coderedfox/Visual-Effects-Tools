'''
    Show what copy of a particular piece of software is installed on your
    Windows nodes in the 'Extra Info 0' column.
'''

from System.Diagnostics import *
from System.IO import *
from System import TimeSpan

from Deadline.Events import *
from Deadline.Scripting import *

import os, socket


def GetDeadlineEventListener():
    return ConfigSlaveEventListener()


def CleanupDeadlineEventListener(eventListener):
    eventListener.Cleanup()


class ConfigSlaveEventListener (DeadlineEventListener):
    def __init__(self):
        self.OnSlaveStartedCallback += self.OnSlaveStarted

    def Cleanup(self):
        del self.OnSlaveStartedCallback

    # This is called every time the Slave starts
    def OnSlaveStarted(self, slavename):
        ServerList = self.GetConfigEntry("Server List")
        ExtraInfoNumber = self.GetConfigEntry("Extra Info Number")

        slave = RepositoryUtils.GetSlaveSettings(slavename, True)
        
        exec('slave.SlaveExtraInfo' + ExtraInfoNumber + ' = self.GetServers(ServerList)')
        
        RepositoryUtils.SaveSlaveSettings(slave)

    def GetServers(self, serverList):
        serverList = serverList.split(',')
        serverFound = []
        serverNotFound = []

        for servers in serverList :
            try:
                serverisFound = socket.gethostbyname(servers)
                print "Conected: " + servers +" : " + serverisFound
            except:
                serverNotFound.append( servers )
                print "FAILED: " + servers
                pass
            
        missing_server = ""
        for missing in serverNotFound:
            missing_server = (missing_server + missing + " ")

        if missing_server=='':
            missing_server = "PASSED: All Servers Connected"
        else:
            missing_server = "NOT CONNECTED: " + missing_server
        return ( missing_server )