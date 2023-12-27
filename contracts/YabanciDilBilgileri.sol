// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";
import "./BaseProperties.sol";

contract YabanciDilBilgileri is BaseProperties {
    uint public id;
    BaseContract baseContract;

    struct YabanciDilBilgi {
        uint id;
        address talepEdilenKurum;
        OnaylayanKurum onayKurumTipi;
        uint basTarih;
        uint bitTarih;
        OgretimTipi ogretimTipi;
        uint32 dilId;
        Seviye seviye;
        Onay onayBilgi;
    }

    mapping(address => mapping(uint => YabanciDilBilgi)) public yabanciDilBilgiListesi;
    address[] public onayBekleyenKisiler;
    YabanciDilBilgi[] public yabanciDilBilgileri;
    mapping(address => uint[]) public kisiYabanciDilIdListesi;

    event YabanciDilEklendiLog(OnaylayanKurum _onaylayanKurumTipi, uint _basTarih, uint _bitTarih, OgretimTipi _ogretimTipi, uint32 _dilId);
    event YabanciDilGuncellendiLog(OnaylayanKurum _onaylayanKurumTipi, uint _basTarih, uint _bitTarih, OgretimTipi _ogretimTipi, uint32 _dilId);
    event YabanciDilTalepEdildiLog(address _talepEdilenKurum, uint _basTarih, uint _bitTarih, OgretimTipi _ogretimTipi, uint32 _dilId);
    event YabanciDilTalebiOnaylandiLog(address _onayKurumAdres, uint _tarih);

    constructor(address baseAddress)  {
        baseContract = BaseContract(baseAddress);
        id = 1;
    }

    modifier _yetkiliPaydas{
        require(baseContract.isUniversite(msg.sender) || baseContract.isFirma(msg.sender) || baseContract.isKamuKurumu(msg.sender) 
        || baseContract.isKurs(msg.sender)||baseContract.isSTK(msg.sender)||baseContract.isSertifikaMerkezi(msg.sender),
            "Sadece yetkili paydas bu islemi yapabilir."
        );
        _;
    }
    modifier _sadeceKisi{
        require(baseContract.isKisi(msg.sender),
            "Bu islemi sadece Kisi yapabilir."
        );
        _;
    }
    function ekleYabanciDilBilgi(address _kisiAddress, OnaylayanKurum onayKurumTipi, uint basTarih, uint bitTarih, OgretimTipi ogretimTipi, uint32 dilId, Seviye seviye) public _yetkiliPaydas {
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        uint yeniId = id++;

        yabanciDilBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].onayKurumTipi = onayKurumTipi;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].basTarih = basTarih;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].bitTarih = bitTarih;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].ogretimTipi = ogretimTipi;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].dilId = dilId;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].seviye = seviye;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.Onaylandi;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman = block.timestamp;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].onayBilgi.adres = msg.sender;
        kisiYabanciDilIdListesi[_kisiAddress].push(yeniId);
        emit YabanciDilEklendiLog(onayKurumTipi, basTarih, bitTarih, ogretimTipi, dilId);
    }

    function guncelleYabanciDilBilgi(address _kisiAddress, uint ydBilgiId, OnaylayanKurum onayKurumTipi, uint basTarih, uint bitTarih, OgretimTipi ogretimTipi, uint32 dilId, Seviye seviye) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].id > 1, "Kisinin bu adres ve calisma id degeri ile kaydi yoktur.");

        yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].onayKurumTipi = onayKurumTipi;
        yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].basTarih = basTarih;
        yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].bitTarih = bitTarih;
        yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].ogretimTipi = ogretimTipi;
        yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].dilId = dilId;
        yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].seviye = seviye;
        yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].onayBilgi.zaman = block.timestamp;
        yabanciDilBilgiListesi[_kisiAddress][ydBilgiId].onayBilgi.adres = msg.sender;

        emit YabanciDilGuncellendiLog(onayKurumTipi, basTarih, bitTarih, ogretimTipi, dilId);
        return ydBilgiId;

    }

    function talepEtYabanciDilBilgi(address _kisiAddress, address _talepEdilenKurum, uint basTarih, uint bitTarih, OgretimTipi ogretimTipi, uint32 dilId, Seviye seviye) public {
        require(baseContract.isKisi(_kisiAddress), "Kisi Mevcut Degil");
        require(!onayBekliyorMu(_kisiAddress), "Kisinin daha onceden onay bekleyen bir talebi vardir.");
        uint yeniId = id++;

        yabanciDilBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].talepEdilenKurum = _talepEdilenKurum;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].basTarih = basTarih;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].bitTarih = bitTarih;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].ogretimTipi = ogretimTipi;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].dilId = dilId;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].seviye = seviye;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.OnayBekliyor;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman = block.timestamp;
        yabanciDilBilgiListesi[_kisiAddress][yeniId].onayBilgi.adres = msg.sender;

        onayBekleyenKisiler.push(_kisiAddress);
        kisiYabanciDilIdListesi[_kisiAddress].push(yeniId);

        emit YabanciDilTalepEdildiLog(_talepEdilenKurum, basTarih, bitTarih, ogretimTipi, dilId);
    }

    function talepOnaylaYabanciDilBilgi(address _kisiAddress, uint ydBilgiBilgiId) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(onayBekleyenKisiVeIdMevcutMu(_kisiAddress, ydBilgiBilgiId), "Kisinin onay bekleyen bir talebi yoktur.");
        require(yabanciDilBilgiListesi[_kisiAddress][ydBilgiBilgiId].talepEdilenKurum == msg.sender, "Sadece Talep edilen kurum onaylayabilir.");

        yabanciDilBilgiListesi[_kisiAddress][ydBilgiBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        yabanciDilBilgiListesi[_kisiAddress][ydBilgiBilgiId].onayBilgi.adres = msg.sender;
        yabanciDilBilgiListesi[_kisiAddress][ydBilgiBilgiId].onayBilgi.zaman = block.timestamp;
        silOnayBekleyenListe(_kisiAddress);
        emit YabanciDilTalebiOnaylandiLog(msg.sender, block.timestamp);
        return ydBilgiBilgiId;

    }

    function getirOnayBekleyenListe() public view returns (address[] memory){
        return onayBekleyenKisiler;
    }

    function getirKisininYabanciDilIdListe(address _kisiAddress) public view returns (uint[] memory){
        return kisiYabanciDilIdListesi[_kisiAddress];
    }

    function getirKisininYabanciDilBilgisi(address _kisiAddress, uint _id) public view returns (YabanciDilBilgi memory){
        return yabanciDilBilgiListesi[_kisiAddress][_id];
    }

    function getirKisininDilListesi(address _kisiAddress) public returns (YabanciDilBilgi[] memory){
     uint[] memory idliste =  getirKisininYabanciDilIdListe(_kisiAddress);
    
        for (uint i = 0; i < idliste.length ; i++) {
             yabanciDilBilgileri.push(getirKisininYabanciDilBilgisi(_kisiAddress,idliste[i]));
            }
        return yabanciDilBilgileri;
    }

    function silOnayBekleyenListe(address _kisiAddress) private {

        require(onayBekleyenKisiler.length > 0, "Onay Bekleyen Listesi Bostur");

        if (onayBekleyenKisiler[onayBekleyenKisiler.length - 1] == _kisiAddress) {
            onayBekleyenKisiler.pop();
            return;
        }

        bool kisiVarMi = false;
        uint index;

        for (uint i = 0; i < onayBekleyenKisiler.length - 1; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress) {
                onayBekleyenKisiler[i] = onayBekleyenKisiler[i + 1];
                kisiVarMi = true;
                index = i;
            }
        }

        if (kisiVarMi == false) revert("Kisi Onay Bekleyen Listesinde Yoktur.");

        for (uint i = index; i < onayBekleyenKisiler.length - 1; i++) {
            onayBekleyenKisiler[i] = onayBekleyenKisiler[i + 1];
        }

        delete onayBekleyenKisiler[onayBekleyenKisiler.length - 1];
        onayBekleyenKisiler.pop();
    }

    function onayBekliyorMu(address _kisiAddress) private view returns (bool){
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress) {
                return true;
            }
        }
        return false;
    }

    function onayBekleyenKisiVeIdMevcutMu(address _kisiAddress, uint _ydBilgiId) private view returns (bool){
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress
            && yabanciDilBilgiListesi[_kisiAddress][_ydBilgiId].id > 0
                && yabanciDilBilgiListesi[_kisiAddress][_ydBilgiId].onayBilgi.durum == OnayDurum.OnayBekliyor) {
                return true;
            }
        }
        return false;
    }

}