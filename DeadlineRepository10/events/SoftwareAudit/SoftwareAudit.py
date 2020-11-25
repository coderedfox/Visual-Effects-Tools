'''
    Show what copy of a particular piece of software is installed on your
    Windows nodes in the 'Extra Info 0' column.
'''

from System.Diagnostics import *
from System.IO import *
from System import TimeSpan

from Deadline.Events import *
from Deadline.Scripting import *

import _winreg


def GetDeadlineEventListener():
    return ConfigSlaveEventListener()


def CleanupDeadlineEventListener(eventListener):
    eventListener.Cleanup()


class ConfigSlaveEventListener (DeadlineEventListener):
    def __init__(self):
        self.OnSlaveStartedCallback += self.OnSlaveStarted

    def Cleanup(self):
        del self.OnSlaveStartedCallback

    def OnSlaveStarted(self, slavename):
        SoftwareList = self.GetConfigEntry("Software List")
        ExtraInfoNumber = self.GetConfigEntry("Extra Info Number")

        slave = RepositoryUtils.GetSlaveSettings(slavename, True)
        
        exec('slave.SlaveExtraInfo' + ExtraInfoNumber + ' = self.GetSoftware(SoftwareList)')
        
        RepositoryUtils.SaveSlaveSettings(slave)

    def GetSoftware(self, software_title):
        software_title = software_title.split(',')
        software_name = []

        # Query uninstall paths
        hKeys = ['HKEY_LOCAL_MACHINE','HKEY_USER']
        sub_keys = [r'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',r'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall']
        hKey = _winreg.OpenKey(_winreg.HKEY_USERS, '')
        subkeyCnt, valuesCnt, modtime = _winreg.QueryInfoKey(hKey)

        # Looks in the USERS reg
        for n in xrange(subkeyCnt):     
            hKey = _winreg.OpenKey(_winreg.HKEY_USERS, '')
            hkeyUser = _winreg.EnumKey(hKey, n)+'\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
            sub_keys.append(hkeyUser)     

        print ("\tSoftware Audit --------------------------------------")
        for software in software_title:
            for hKey in hKeys:
                if hKey=='HKEY_LOCAL_MACHINE':
                    keytype = _winreg.HKEY_LOCAL_MACHINE
                if hKey=='HKEY_USER':
                    keytype = _winreg.HKEY_USERS    
                
                for sub_key in sub_keys:
                    try:
                        keyLocal = _winreg.OpenKey(keytype, sub_key, 0, _winreg.KEY_READ)
                    
                        for j in range(0, _winreg.QueryInfoKey(keyLocal)[0]-1):
                            try:
        
                                key_name = _winreg.EnumKey(keyLocal, j)
                                key_path = sub_key + '\\' + key_name

                                each_key = _winreg.OpenKey(keytype, key_path, 0, _winreg.KEY_READ)                        
                                DisplayName, REG_SZ = _winreg.QueryValueEx(each_key, 'DisplayName')
                                DisplayVersion, REG_SZ = _winreg.QueryValueEx(each_key, 'DisplayVersion')                        
                                if software in DisplayName:
                                    software_name.append(DisplayName + " : "+ DisplayVersion +" | ")
                            except WindowsError:
                                continue
                    except WindowsError:
                            continue

        #software_name = list(set(software_name))
        #software_name = sorted(software_name)       

        found_software = ""
        for found in software_name:
            found_software = (found_software + found + " ")
            print  ("found_software : " + found )
        return ( found_software )

print ("Starting software Audit")