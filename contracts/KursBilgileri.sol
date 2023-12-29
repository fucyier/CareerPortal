// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";
import "./BaseProperties.sol";

contract KursBilgileri is BaseProperties {
    uint public id;
    BaseContract baseContract;

    struct KursBilgi {
        uint id;
        address talepEdilenKurum;
        uint basTarih;
        uint bitTarih;
        uint8 sure;
        string egitimAdi;
        Onay onayBilgi;
    }

    mapping(address => mapping(uint => KursBilgi)) public kursBilgiListesi;
    address[] public onayBekleyenKisiler;
    KursBilgi[] public kursBilgileri;
     KursBilgi[] public onayBekleyenler;
    mapping(address => uint[]) public kisiKursIdListesi;


    event KursEklendiLog(address _kisiAddress, uint _basTarih, uint _bitTarih, uint8 _sure);
    event KursGuncellendiLog(address _kisiAddress, uint _basTarih, uint _bitTarih, uint8 _sure);
    event KursTalepEdildiLog(address _talepEdilenKurum, uint _basTarih, uint _bitTarih, uint8 _sure);
    event KursTalebiOnaylandiLog(address _onayKurumAdres, uint _tarih);

    constructor(address baseAddress)  {
        baseContract = BaseContract(baseAddress);
        id = 1;
    }
    modifier _yetkiliPaydas{
        require(baseContract.isKurs(msg.sender),
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
    function ekleKursBilgi(address _kisiAddress, uint basTarih, uint bitTarih, uint8 sure, string memory egitimAdi) public _yetkiliPaydas {
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        uint yeniId = id++;

        kursBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        kursBilgiListesi[_kisiAddress][yeniId].basTarih = basTarih;
        kursBilgiListesi[_kisiAddress][yeniId].bitTarih = bitTarih;
        kursBilgiListesi[_kisiAddress][yeniId].sure = sure;
        kursBilgiListesi[_kisiAddress][yeniId].egitimAdi = egitimAdi;
        kursBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.Onaylandi;
        kursBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman = block.timestamp;
        kursBilgiListesi[_kisiAddress][yeniId].onayBilgi.onayAdres = msg.sender;

        kisiKursIdListesi[_kisiAddress].push(yeniId);
        emit KursEklendiLog(_kisiAddress, basTarih, bitTarih, sure);
    }

    function guncelleKursBilgi(address _kisiAddress, uint _kursBilgiId, uint basTarih, uint bitTarih, uint8 sure, string memory egitimAdi) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(kursBilgiListesi[_kisiAddress][_kursBilgiId].id > 1, "Kisinin bu adres ve kurs id degeri ile kaydi yoktur.");

        kursBilgiListesi[_kisiAddress][_kursBilgiId].basTarih = basTarih;
        kursBilgiListesi[_kisiAddress][_kursBilgiId].bitTarih = bitTarih;
        kursBilgiListesi[_kisiAddress][_kursBilgiId].sure = sure;
        kursBilgiListesi[_kisiAddress][_kursBilgiId].egitimAdi = egitimAdi;

        kursBilgiListesi[_kisiAddress][_kursBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        kursBilgiListesi[_kisiAddress][_kursBilgiId].onayBilgi.zaman = block.timestamp;
        kursBilgiListesi[_kisiAddress][_kursBilgiId].onayBilgi.onayAdres = msg.sender;

        emit KursGuncellendiLog(_kisiAddress, basTarih, bitTarih, sure);
        return _kursBilgiId;

    }

    function talepEtKursBilgi(address _kisiAddress, address _talepEdilenKurum, uint basTarih, uint bitTarih, uint8 sure, string memory egitimAdi) public {
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(!onayBekliyorMu(_kisiAddress), "Kisinin daha onceden onay bekleyen bir talebi vardir.");

        uint yeniId = id++;

        kursBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        kursBilgiListesi[_kisiAddress][yeniId].talepEdilenKurum = _talepEdilenKurum;
        kursBilgiListesi[_kisiAddress][yeniId].basTarih = basTarih;
        kursBilgiListesi[_kisiAddress][yeniId].bitTarih = bitTarih;
        kursBilgiListesi[_kisiAddress][yeniId].sure = sure;
        kursBilgiListesi[_kisiAddress][yeniId].egitimAdi = egitimAdi;
        kursBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.OnayBekliyor;
        kursBilgiListesi[_kisiAddress][yeniId].onayBilgi.onayAdres = _kisiAddress;
        
        onayBekleyenKisiler.push(_kisiAddress);
        kisiKursIdListesi[_kisiAddress].push(yeniId);

        emit KursEklendiLog(_talepEdilenKurum, basTarih, bitTarih, sure);
    }

    function talepOnaylaKursBilgi(address _kisiAddress, uint _kursBilgiId) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(onayBekleyenKisiVeIdMevcutMu(_kisiAddress, _kursBilgiId), "Kisinin onay bekleyen bir talebi yoktur.");
        require(kursBilgiListesi[_kisiAddress][_kursBilgiId].talepEdilenKurum == msg.sender, "Sadece Talep edilen kurum onaylayabilir.");

        kursBilgiListesi[_kisiAddress][_kursBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        kursBilgiListesi[_kisiAddress][_kursBilgiId].onayBilgi.onayAdres = msg.sender;
        kursBilgiListesi[_kisiAddress][_kursBilgiId].onayBilgi.zaman = block.timestamp;
        silOnayBekleyenListe(_kisiAddress);
        emit KursTalebiOnaylandiLog(msg.sender, block.timestamp);
        return _kursBilgiId;

    }

    function getirOnayBekleyenListe() public view returns (address[] memory){
        return onayBekleyenKisiler;
    }

    function getirKisininKursIdListe(address _kisiAddress) public view returns (uint[] memory){
        return kisiKursIdListesi[_kisiAddress];
    }

    function getirKisininKursBilgisi(address _kisiAddress, uint _id) public view returns (KursBilgi memory){
        return kursBilgiListesi[_kisiAddress][_id];
    }
    
    function getirKisininKursListesi(address _kisiAddress) public returns (KursBilgi[] memory){
     uint[] memory idliste =  getirKisininKursIdListe(_kisiAddress);
    
        for (uint i = 0; i < idliste.length; i++) {
             kursBilgileri.push(getirKisininKursBilgisi(_kisiAddress,idliste[i]));
            }
        return kursBilgileri;
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

    function onayBekleyenKisiVeIdMevcutMu(address _kisiAddress, uint _kursId) private view returns (bool){
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress
            && kursBilgiListesi[_kisiAddress][_kursId].id > 0
                && kursBilgiListesi[_kisiAddress][_kursId].onayBilgi.durum == OnayDurum.OnayBekliyor) {
                return true;
            }
        }
        return false;
    }
 function getirOnayBekleyenListesi2() public  returns (KursBilgi[] memory){

        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
              uint[] memory idliste =  getirKisininKursIdListe(onayBekleyenKisiler[i]);
             for (uint j = 0; j < idliste.length; j++){
               
         
            if ( getirKisininKursBilgisi(onayBekleyenKisiler[i],idliste[j]).talepEdilenKurum==msg.sender){
                onayBekleyenler.push(getirKisininKursBilgisi(onayBekleyenKisiler[i],idliste[j]));
             }
            }
        }

        return onayBekleyenler;
    }
}