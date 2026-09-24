function dispatchService()
    for i = 1, 15 do
        EnableDispatchService(i, false)
    end
    SetAudioFlag('PoliceScannerDisabled', true)
end
