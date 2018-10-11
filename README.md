# DigitalReceipt

## 注意点
### 以下为使用cybex时需要导入的静态库和c++头文件
libboost.a, libcrypto.a, libfc.a, libssl.a, secp256k1.a
/Recika/addons/*
/Recika/bitshare-core/*

### project需要进行以下设置
<b>Build Settings  </b>
- Header Search Paths添加  

```
$(inherited)
$(SRCROOT)/Recika/addons/boost/include
$(SRCROOT)/Recika/bitshare-core/include
$(SRCROOT)/Recika/addons/libfc/include
$(SRCROOT)/Recika/addons/openssl/include
```

- Enable Bitcode 设为 No
