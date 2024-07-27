# PyschologyDAO

PyschologyDAO, psikolojik danışmanlık hizmetleriyle ilgili girişimlerin önerilmesi ve oylanması için bir platform sağlayan merkeziyetsiz bir otonom organizasyondur (DAO). Akıllı kontrat Solidity ile yazılmış olup, Ethereum blokzincirinde dağıtılmıştır. İşte kontratın işlevselliği ve metodları hakkında bir özet.

## Genel Bakış

Bu akıllı kontrat, kullanıcıların:
- DAO içinde kullanıcı olarak kaydolmasını,
- Psikolojik danışmanlıkla ilgili öneriler (oneri) sunmasını,
- Sunulan önerilere oy vermesini,
- Belirli bir oy eşiğine ulaşan önerilerin otomatik olarak uygulanmasını sağlar.

## Kontrat Detayları

### Struct'lar

#### Oneri
```solidity
struct Oneri {
    uint id;
    string aciklama;
    uint oySayisi;
    bool uygulandi;
}
```
Bir öneriyi, ID, açıklama (`aciklama`), oy sayısı (`oySayisi`) ve durum (`uygulandi`) ile temsil eder.

#### Kullanici
```solidity
struct Kullanici {
    address adres;
    string isim;
    string soyisim;
}
```
Bir kullanıcıyı, adres, isim (`isim`) ve soyisim (`soyisim`) ile temsil eder.

### Durum Değişkenleri

- `address public sahip`: Sahip adresi.
- `uint public sonrakiOneriId`: Bir sonraki öneri ID'si.
- `uint public oneriEsigi`: Bir önerinin uygulanması için gereken oy eşiği.
- `uint public kullaniciSayisi`: Kullanıcı sayısı.
- `uint256 public oneriSayisi`: Öneri sayısı.

### Eşlemeler

- `mapping(uint => Oneri) public oneriler`: Öneri ID'lerini ilgili önerilere eşler.
- `mapping(address => mapping(uint => bool)) public oylar`: Bir kullanıcının belirli bir öneriye oy verip vermediğini takip eder.
- `mapping(address => Kullanici) public kullanicilar`: Kullanıcı adreslerini ilgili kullanıcı detaylarına eşler.

### Event'ler

- `event OneriOlusturuldu(uint id, string aciklama)`: Yeni bir öneri oluşturulduğunda tetiklenir.
- `event OyVerildi(uint oneriId, address oyveren)`: Bir oy verildiğinde tetiklenir.
- `event OneriUygulandi(uint id, string aciklama)`: Bir öneri uygulandığında tetiklenir.
- `event KullaniciOlustu(address id, string isim, uint256 date)`: Yeni bir kullanıcı kaydedildiğinde tetiklenir.

### Modifiers

- `modifier kullaniciVar(address _id)`: Kullanıcının var olup olmadığını kontrol eder.
- `modifier sadeceSahip()`: Fonksiyon erişimini sadece sahibine kısıtlar.
- `modifier sadeceTekOy(uint oneriId)`: Kullanıcının belirli bir öneriye zaten oy verip vermediğini kontrol eder.

### Kurucu Fonksiyon

```solidity
constructor(uint _oneriEsigi) {
    sahip = msg.sender;
    oneriEsigi = _oneriEsigi;
}
```
Kontratı sahip ve oy eşiği ile başlatır.

### Fonksiyonlar

#### kullaniciEkle
```solidity
function kullaniciEkle(string memory _isim, string memory _soyisim) public
```
Bir kullanıcıyı isim ve soyisim ile kaydeder.

#### oneriOlustur
```solidity
function oneriOlustur(string memory _aciklama) public sadeceSahip kullaniciVar(msg.sender)
```
Sahibin yeni bir öneri oluşturmasına izin verir.

#### oyVer
```solidity
function oyVer(uint oneriId) public sadeceTekOy(oneriId) kullaniciVar(msg.sender)
```
Kullanıcıların bir öneriye oy vermesine izin verir. Oy eşiğine ulaşan öneri otomatik olarak uygulanır.

#### oneriUygula
```solidity
function oneriUygula(uint oneriId) internal
```
Oy eşiğine ulaşan öneriyi uygular.

#### oneriGetir
```solidity
function oneriGetir(uint oneriId) public view returns (uint, string memory, uint, bool)
```
Belirli bir öneriyi ID ile getirir.

#### tumOnerileriGetir
```solidity
function tumOnerileriGetir() public view returns (Oneri[] memory)
```
Tüm önerileri getirir.

## Kullanım

1. **Kontratı Dağıtın**: `PyschologyDAO` kontratını Ethereum ağına oy eşiği ile birlikte dağıtın.
2. **Kullanıcıları Kaydedin**: Kullanıcılar `kullaniciEkle` fonksiyonunu kullanarak kaydolur.
3. **Öneriler Oluşturun**: Sahip, `oneriOlustur` fonksiyonunu kullanarak öneriler oluşturur.
4. **Önerilere Oy Verin**: Kayıtlı kullanıcılar `oyVer` fonksiyonunu kullanarak önerilere oy verir.
5. **Önerileri Uygulayın**: Oy eşiğine ulaşan öneriler kontrat tarafından otomatik olarak uygulanır.

Bu kontrat, psikolojik danışmanlık alanındaki girişimler için işbirlikçi karar verme sürecini kolaylaştırmayı amaçlamaktadır. Danışanlar ve terapistler, öneriler sunabilir ve topluluk oylamalarıyla kararlar alabilir. Tüm veriler, gizlilik ve güvenlik sağlamak için blockchain üzerinde saklanır. Bu sayede, topluluk üyeleri terapist seçimi ve eğitim programları gibi konularda etkin rol oynar.
