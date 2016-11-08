pin = 2
ow.setup(pin)
count = 0
newaddr = nil
addr = nil
addrs = {}
i = 0
ow.reset_search(pin)
repeat
  count = count + 1
  newaddr = ow.search(pin)
  if (newaddr ~= nil) then
     addrs[i]=newaddr
     print("i: ",i,"addr: ",newaddr:byte(1,8))
     i = i + 1
  end
  tmr.wdclr()
until((count > 100))

