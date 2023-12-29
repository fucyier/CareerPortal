// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";
import "./BaseProperties.sol";

contract ReferansBilgileri is BaseProperties {
    uint public id;
    BaseContract baseContract;

    struct ReferansBilgi {
        uint id;
        address referansAdres;
        string aciklama;
        string pozisyon;
        Onay onayBilgi;
    }


    mapping(address => mapping(uint => ReferansBilgi)) public referansBilgiListesi;
  ReferansBilgi[] public referansBilgileri;
    mapping(address => uint[]) public kisiReferansIdListesi;

    event ReferansTalepEtLog(uint id, address _kisiAdres, address _referansAdres, OnayDurum _durum);
    event ReferansOnayRedLog(uint referansId, address _kisiAddress, address _referansAdres, bool onayRed, uint zaman);

    constructor(address baseAddress)  {
        baseContract = BaseContract(baseAddress);
        id = 1;
    }

    modifier _sadeceKisi{
        require(baseContract.isKisi(msg.sender),
            "Bu islemi sadece Kisi yapabilir."
        );
        _;
    }

    function talepEtReferans(address _kisiAddress, address referansAdres, string memory pozisyon) public _sadeceKisi {
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");

        require(baseContract.isKisi(referansAdres), "Referans Kisi mevcut degil");
        uint yeniId = id++;

        referansBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        referansBilgiListesi[_kisiAddress][yeniId].referansAdres = referansAdres;
        referansBilgiListesi[_kisiAddress][yeniId].pozisyon = pozisyon;
        referansBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.OnayBekliyor;
        referansBilgiListesi[_kisiAddress][yeniId].onayBilgi.talepAdres = _kisiAddress;
        
         kisiReferansIdListesi[_kisiAddress].push(yeniId);
        emit ReferansTalepEtLog(yeniId, _kisiAddress, referansAdres, OnayDurum.OnayBekliyor);
    }


    function onayRedReferans(address _kisiAddress, uint referansId, bool accepted, string memory aciklama) public _sadeceKisi {
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");

        require(baseContract.isKisi(msg.sender), "Referans olan Kisi mevcut degil");

        require(referansBilgiListesi[_kisiAddress][referansId].referansAdres == msg.sender,
            "Yalnizca kendinize atanan belgeye onay/red verebilirsiniz"
        );

        require(referansBilgiListesi[_kisiAddress][referansId].id > 0 && referansBilgiListesi[_kisiAddress][referansId].onayBilgi.durum == OnayDurum.OnayBekliyor,
            "Referansin yeni olusturulmus durumda olmasi gerekir"
        );
        referansBilgiListesi[_kisiAddress][referansId].aciklama = aciklama;
        referansBilgiListesi[_kisiAddress][referansId].onayBilgi.zaman = block.timestamp;
        referansBilgiListesi[_kisiAddress][referansId].onayBilgi.onayAdres = msg.sender;
        if (accepted) {
            referansBilgiListesi[_kisiAddress][referansId].onayBilgi.durum = OnayDurum.Onaylandi;
        }
        else {
            referansBilgiListesi[_kisiAddress][referansId].onayBilgi.durum = OnayDurum.Reddedildi;
        }

        emit ReferansOnayRedLog(referansId, _kisiAddress, msg.sender, accepted, block.timestamp);
    }



  function getirKisininReferansIdListe(address _kisiAddress) public view returns (uint[] memory){
        return kisiReferansIdListesi[_kisiAddress];
    }

    function getirKisininReferansBilgisi(address _kisiAddress, uint _id) public view returns (ReferansBilgi memory){
        return referansBilgiListesi[_kisiAddress][_id];
    }
    
    function getirKisininReferansListesi(address _kisiAddress) public returns (ReferansBilgi[] memory){
     uint[] memory idliste =  getirKisininReferansIdListe(_kisiAddress);
    
        for (uint i = 0; i < idliste.length ; i++) {
             referansBilgileri.push(getirKisininReferansBilgisi(_kisiAddress,idliste[i]));
            }
        return referansBilgileri;
    }
}