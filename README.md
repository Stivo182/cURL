[![Release](https://img.shields.io/github/release/Stivo182/curl.svg)](https://github.com/Stivo182/curl/releases)
[![Статус порога качества](https://sonar.openbsl.ru/api/project_badges/measure?project=curl&metric=alert_status&token=sqb_c82633798d56e9c8cb7596cdc9b58cb18d23e356)](https://sonar.openbsl.ru/dashboard?id=curl)

# cURL для 1С:Предприятие 8

Обработка является облочкой над утилитой [cURL](https://curl.se/)

## Подключение:

### 1. Установка утилиты cURL

#### Windows:
- Установить последнюю версию [cURL](https://curl.se/windows)
- Указать путь к папке расположения `curl.exe` в перемменную среды `Path` до `C:\Windows\system32`

> [!TIP]
> Если путь к папке `curl.exe` не указан в переменной среды `Path`, то можно вызвать метод `УказатьИсполняемыйФайл` с указанием местоположения исполняемого файла `curl.exe`:
> ```bsl
> Curl.УказатьИсполняемыйФайл("path/to/curl.exe");
> ```
___

### 2. Подключение обработки

#### 1. Использование в составе конфигурации/расширения
1. Добавить обработку в конфигурацию/расширение
2. Создать объект обработки: `Curl = Обработки.cURL.Создать();`

#### 2. Использование в составе другой обработки
1. Добавить обработку в макет другой обработки с именем `cURL`
2. Подключить обработку:
* В модуле формы:
```bsl
ОбъектОбработки = РеквизитФормыВЗначение("Объект");       
ДвоичныеДанные = ОбъектОбработки.ПолучитьМакет("cURL");               
АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
ВнешниеОбработки.Подключить(АдресХранилища,, Ложь);
```
* В модуле объекта:
```bsl    
ДвоичныеДанные = ПолучитьМакет("cURL");               
АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
ВнешниеОбработки.Подключить(АдресХранилища,, Ложь);
```
3. Создать объект обработки: `Curl = ВнешниеОбработки.Создать("cURL",, Ложь);`

___

## Примеры использования:

### 1. Get методы

#### Отправка `HTTP GET` запроса без обработки результата

```bsl
Curl.Get("https://example.com/");
```

#### Скачивание файла

```bsl
ПутьКФайлу = Curl.GetFile("ftp://ftp.example.com/file.zip");
```

#### Получение текстовых данных

Вариант 1:
```bsl
Текст = Curl.GetString("https://example.com/");
```

Вариант 2:
```bsl
Текст = Curl
        .Get("ftp://ftp.example.com/README")
        .ОтветКакТекст();
```

#### Получение десериализованного JSON

Вариант 1:
```bsl
Json = Curl.GetJson("https://example.com/v1/api");
```

Вариант 2:
```bsl
Json = Curl
        .Get("https://example.com/v1/api")
        .ОтветКакJson();
```

#### Получение двоичных данных

Вариант 1:
```bsl
ДвоичныеДанные = Curl.GetBinaryData("ftp://ftp.example.com/file.zip");
```

Вариант 2:
```bsl
ДвоичныеДанные = Curl
        .Get("https://example.com/file.zip")
        .ОтветКакДвоичныеДанные();
```
___

### 2. POST (HTTP)

#### Отправка `POST` запроса без обработки результата

```bsl
Curl.Post("https://example.com/v1/api");
```

#### Отправка `POST` запроса с телом без обработки результата

```bsl
ТелоЗапроса = Новый Структура();
ТелоЗапроса.Вставить("Name", "Jhon");
ТелоЗапроса.Вставить("BirthDate", Дата(2020, 1, 1));
ТелоЗапроса.Вставить("IsEmploee", Истина);

Curl.Post("https://example.com/v1/api", ТелоЗапроса);
```

> [!NOTE]
> В качестве тела запроса можно передавать параметр с типами: `Строка`, `Структура`, `Соответствие`, `ДвоичныеДанные`, `Файл`.
> <br>Тип `Строка` может также содержать путь к файлу на диске или адрес двоичных данных во временном хранилище.

#### Получение результата запроса в текстовом формате

```bsl
Текст = Curl
        .Post("https://example.com/v1/api", ТелоЗапроса)
        .ОтветКакТекст();
```

#### Получение результата запроса в формате десериализованного JSON

```bsl
Json = Curl
        .Post("https://example.com/v1/api", ТелоЗапроса)
        .ОтветКакJson();
```

#### Получение результата запроса в формате двоичных данных

```bsl
ДвоичныеДанные = Curl
        .Post("https://example.com/v1/api", ТелоЗапроса)
        .ОтветКакДвоичныеДанные();
```

#### Получение файла результата запроса

```bsl
ПутьКФайлу = Curl
        .Post("https://example.com/v1/api", ТелоЗапроса)
        .ОтветКакПутьФайлу();
```
___

### 3. PUT (HTTP)

Выполнение `PUT` запроса выполняется следующим образом:
```bsl
Curl.Put("https://example.com/put", Данные);
```

> [!NOTE]
> В качестве данных запроса можно передавать параметр с типами: `Строка`, `Структура`, `Соответствие`, `ДвоичныеДанные`, `Файл`.
> <br>Тип `Строка` может также содержать путь к файлу на диске или адрес двоичных данных во временном хранилище.

> [!TIP]
> Для передачи файла можно использовать метод `UploadFile`
___

### 4. Передача файла

#### Передача файла на FTP сервер
```bsl
Curl.UploadFile("ftp://ftp.example.com/new.zip", Файл);
```

#### Передача файла по протоколу HTTP (PUT)
```bsl
Curl.UploadFile("https://example.com/new.html", Файл);
```

> [!NOTE]
> Файл может быть представлен типами: `Строка`, `ДвоичныеДанные`, `Файл`.
> <br>Переменная с типом `Строка` должна содержать путь к файлу на диске или адрес двоичных данных во временном хранилище.
___

### 5. Код состояния ответа

Для протоколов `HTTP` и `FTP` реализована возможность получения кода состояния ответа:

```bsl
КодСостояния = Curl.Get("https://example.com/").КодСостояния();
```

___

### 6. Работа с HTTP заголовками

#### Установка заголовков запроса

Вариант 1:
```bsl
Заголовки = Новый Соответствие;
Заголовки.Вставить("Accept-Language", "en-US,en;q=0.9");
Заголовки.Вставить("Content-Type", "application/json");
Заголовки.Вставить("Cookie", "name1=value2; name2=value2");

Curl.УстановитьЗаголовки(Заголовки);
```

Вариант 2:
```bsl
Curl.УстановитьЗаголовок("Accept-Language", "en-US,en;q=0.9");
Curl.УстановитьЗаголовок("Content-Type", "application/json");
Curl.УстановитьЗаголовок("Cookie", "name1=value2; name2=value2");
```

Вариант 3:
```bsl
Текст =
"Accept-Language: en-US,en;q=0.9
|Content-Type: application/json
|Cookie: name1=value2; name2=value2";

Curl.УстановитьЗаголовки(Текст);
```

#### Получение заголовков ответа 

Получение всех заголовков ответа:
```bsl
ЗаголовкиОтвета = Curl
        .Get("https://example.com/")
        .ЗаголовкиОтвета();
```

Получение заголовка по имени:
```bsl
Curl.Get("https://example.com/");

ЗначениеЗаголовка1 = Curl.ЗаголовокОтвета("Content-Type");
ЗначениеЗаголовка2 = Curl.ЗаголовокОтвета("Content-Encoding");
```
___

### 7. Аутентификация

#### Базовая аутентификация
```bsl
Curl.Аутентификация("user", "password")
```

#### (HTTP) Digest-аутентификация
```bsl
Curl.АутентификацияDigest("user", "password")
```

#### (HTTP) AWS V4 Signature аутентификация
```bsl
КлючДоступа = "access_key";
СекретныйКлюч = "secret_key";
Регион = "eu-west-1";
Сервис = "s3";

Curl.АутентификацияAWS4(КлючДоступа, СекретныйКлюч, Регион, Сервис);
```
___

### 8. Прокси

Установка прокси:
```bsl
ИнтернетПрокси = Новый ИнтернетПрокси;
ИнтернетПрокси.Установить(Протокол, Адрес, Порт, Логин, Пароль);

Curl.УстановитьПрокси(ИнтернетПрокси)
```
___

### 9. Работа с cookie

При выполнении запроса и получения от сервера новых куки через заголовок ответа `Set-Cookie`, новые куки добавляются к текущим.

#### Отключение автоматического обновления куки:
```bsl
Curl.ОбновлятьКуки(Ложь)
```

#### Принудительное обновление куки:
```bsl
Curl.ОбновитьКуки()
```

#### Получение куки:
```bsl
Куки = Curl.Куки()
```
строкой:
```bsl
КукиСтрокой = Curl.КукиСтрокой()
```

#### Получение только новых куки полученые из заголовка ответа `Set-Cookie`:
```bsl
Куки = Curl.КукиИзОтвета()
```
строкой:
```bsl
КукиСтрокой = Curl.КукиИзОтветаСтрокой()
```
___

### 10. Перенаправление запроса на новый адрес

По умолчанию перенаправление на новый адрес отключено, если сервер вернул ответ с кодом состояния 3XX. Для включения перенаправления необходимо вызвать метод `ПеренаправлятьЗапрос`.

Включение перенаправления:
```bsl
Curl.ПеренаправлятьЗапрос()
```
либо
```bsl
Curl.ПеренаправлятьЗапрос(Истина)
```

Если перенаправление выполняется на другой хост, то по умолчанию данные об аутентификации не передаются. Для передачи необходимо передать `Истина` в качестве второго параметра:
```bsl
Curl.ПеренаправлятьЗапрос(Истина, Истина)
```

Для отключения перенаправления необходимо передать `Ложь` в качестве первого параметра
```bsl
Curl.ПеренаправлятьЗапрос(Ложь)
```
___

### 11. Эмуляция браузера (Chrome)

При включении режима эмуляции браузера дополнительно передаются HTTP заголовки и шифры, использование TLS 1.2 и HTTP/2, запрос на получение сжатого ответа.

Включение эмуляции:
```bsl
Curl.ЭмуляцияБраузера(Истина)
```

Отключение эмуляции:
```bsl
Curl.ЭмуляцияБраузера(Ложь)
```

> [!NOTE]
> Для использования режима эмуляции браузера необходимо наличие файла с сертификатами удостоверяющих центров `curl-ca-bundle.crt` в папке расположения `curl` либо указать файл с сертификатами используя метод `УстановитьСертификатыУдостоверяющихЦентров`.
___

### 12. Сертификаты

#### Указание сертификата клиента

```bsl
Curl.УстановитьСертификатКлиента(ИмяФайлаСертификата, Пароль);
```

Если сертификат клиента не содержит закрытый ключ, то необходимо его указать:

```bsl
Curl.УстановитьЗакрытыйКлючСертификата(ИмяФайлаЗакрытогоКлюча);
```

#### Указание сертификатов удостоверяющих центров

Использование сертификатов удостоверяющих центров из системного хранилища сертификатов ОС:

```bsl
Curl.ИспользоватьСертификатыУдостоверяющихЦентровИзОС();
```

Указание сертификатов удостоверяющих центров из файла:

```bsl
Curl.УстановитьСертификатыУдостоверяющихЦентров(ИмяФайла);
```
___

### 13. TLS шифры (ciphers)

Использование шифров в соединении:
```bsl
Curl.ДобавитьШифры("TLS_AES_128_GCM_SHA256,TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256")
```
Список шифров можно посмотреть по [ссылке](https://curl.se/docs/ssl-ciphers.html)
___

### 14. Использование нереализованных в обработке опций cURL

Добавление опции:

```bsl
Curl.ДобавитьОпцию("--limit-rate", "1000");
Curl.ДобавитьОпцию("--tlsv1.2");
```

Удаление опции:

```bsl
Curl.УдалитьОпцию("--limit-rate");
```

Очистка всех добавленных опций:

```bsl
Curl.ОчиститьОпции();
```

Все опции утилиты можно посмотреть по [ссылке](https://curl.se/docs/manpage.html)
