// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ПутьКИсполняемомуФайлу; // Строка
Перем НаборШифров; // Массив
Перем ЗаголовкиЗапроса; // Соответствие
Перем ЗаголовкиОтвета; // Массив из Структура
Перем КодСостояния; // Число
Перем РежимЭмуляцииБраузера; // Булево
Перем ИнтернетПрокси; // ИнтернетПрокси, Неопределено
Перем ИмяПользователяНаСервере; // Строка
Перем ПарольПользователяНаСервере; // Строка
Перем СпособАутентификацииНаСервере; // Строка
Перем ПеренаправлятьЗапросПоНовомуURI; // Булево
Перем ВыполнятьАутентификациюПриПеренаправлении; // Булево
Перем ПутьКРезультату; // Строка
Перем ПутьКЗаголовкамОтвета; // Строка
Перем ПутьКЗаголовкамЗапроса; // Строка
Перем ПутьКТелуЗапроса; // Строка

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Выполняет POST запрос.
// 
// Параметры:
//  URL - Строка - URL
//  Тело - Строка - Простой текст, Адрес двоичных данных во временном хранилище 
//       - Структура
//       - Соответствие из КлючИЗначение
//       - ДвоичныеДанные
//       - Файл
//       - Неопределено
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция Post(URL, Тело = Неопределено) Экспорт
	Возврат ОтправитьЗапрос(URL, "POST", Тело);
КонецФункции

// Выполняет GET запрос.
// 
// Параметры:
//  URL - Строка - URL
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция Get(URL) Экспорт
	Возврат ОтправитьЗапрос(URL, "GET");
КонецФункции

// Возвращает путь файлу результата запроса.
// 
// Возвращаемое значение:
//  Строка, Неопределено - Путь файлу результата запроса
Функция ОтветКакПутьФайлу() Экспорт
	
	Если Не ЗначениеЗаполнено(ПутьКРезультату) Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Файл = Новый Файл(ПутьКРезультату);
	Если Файл.Существует() Тогда
		Возврат ПутьКРезультату;
	КонецЕсли;
	
КонецФункции

// Возвращает результат запроса в виде двоичных данных.
// 
// Параметры:
//  УдалитьИзДисковойПамяти - Булево - Удаляет артефакты из дисковой памяти
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено - Двоичные данные результата запроса
Функция ОтветКакДвоичныеДанные(УдалитьИзДисковойПамяти = Истина) Экспорт
	
	ИмяФайла = ОтветКакПутьФайлу();
	
	Результат = Неопределено;
	Если Не ИмяФайла = Неопределено Тогда
		Результат = Новый ДвоичныеДанные(ИмяФайла);
	КонецЕсли;
	
	Если УдалитьИзДисковойПамяти Тогда
		УдалитьАртефакты();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает результат запроса в текстовом виде.
// 
// Параметры:
//  УдалитьИзДисковойПамяти - Булево - Удаляет артефакты из дисковой памяти
// 
// Возвращаемое значение:
//  Строка, Неопределено - Текст результата запроса
Функция ОтветКакТекст(УдалитьИзДисковойПамяти = Истина) Экспорт
	
	ИмяФайла = ОтветКакПутьФайлу();
	
	Результат = Неопределено;
	Если Не ИмяФайла = Неопределено Тогда
		ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
		Результат = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();	
	КонецЕсли;
	
	Если УдалитьИзДисковойПамяти Тогда
		УдалитьАртефакты();
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Возвращает результат запроса в виде JSON.
// 
// Параметры:
//  УдалитьИзДисковойПамяти - Булево - Удаляет артефакты из дисковой памяти
// 
// Возвращаемое значение:
//  Произвольный - JSON структура результата запроса
Функция ОтветКакJson(УдалитьИзДисковойПамяти = Истина) Экспорт
		
	ИмяФайла = ОтветКакПутьФайлу();
	
	Результат = Неопределено;
	Если Не ИмяФайла = Неопределено Тогда
		Результат = ПрочитатьФайлJSON(ИмяФайла);
	КонецЕсли;
	
	Если УдалитьИзДисковойПамяти Тогда
		УдалитьАртефакты();
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Устанавливает HTTP заголовки.
// 
// Параметры:
//  Заголовки - Соответствие из КлючИЗначение
//            - Строка - Строка содержащая пары ключ-значение. Значение от ключа должно быть разделено двоеточием. 
//                       Пары должны быть разделены символом переноса.
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция УстановитьЗаголовки(Заголовки) Экспорт
	Если ТипЗнч(Заголовки) = Тип("Соответствие") Тогда
		ЗаголовкиЗапроса = Заголовки;
	Иначе
		ЗаголовкиЗапроса = ЗаголовкиИзТекста(Заголовки);
	КонецЕсли;
	Возврат ЭтотОбъект;
КонецФункции

// Устанавливает HTTP заголовок.
// 
// Параметры:
//  Имя - Строка - Имя заголовка
//  Значение - Строка - Значение
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция УстановитьЗаголовок(Имя, Значение) Экспорт
	ЗаголовкиЗапроса.Вставить(Имя, Значение);	
	Возврат ЭтотОбъект; 
КонецФункции

// Аутентификация на сервере (Basic Authentication).
// 
// Параметры:
//  ИмяПользователя - Строка - Имя пользователя
//  Пароль - Строка - Пароль
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL 
Функция АутентификацияНаСервере(ИмяПользователя, Пароль) Экспорт
	ИмяПользователяНаСервере = ИмяПользователя;
	ПарольПользователяНаСервере = Пароль;
	СпособАутентификацииНаСервере = СпособАутентификацииНаСервереBasic();
	Возврат ЭтотОбъект;
КонецФункции

// Аутентификация на сервере (Digest Authentication).
// 
// Параметры:
//  ИмяПользователя - Строка - Имя пользователя
//  Пароль - Строка - Пароль
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL 
Функция АутентификацияНаСервереDigest(ИмяПользователя, Пароль) Экспорт
	ИмяПользователяНаСервере = ИмяПользователя;
	ПарольПользователяНаСервере = Пароль;
	СпособАутентификацииНаСервере = СпособАутентификацииНаСервереDigest();
	Возврат ЭтотОбъект;
КонецФункции

// Добавляет шифры в набор.
// 
// Параметры:
//  Шифры - Строка - Шифры
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция ДобавитьШифры(Шифры) Экспорт
	ДополнитьМассив(НаборШифров, СтрРазделить(Шифры, ","), Истина);
	Возврат ЭтотОбъект;
КонецФункции

// Установить исполняемый файл.
// 
// Параметры:
//  Путь - Строка - Путь
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция УказатьИсполняемыйФайл(Путь) Экспорт
	ПутьКИсполняемомуФайлу = Путь;
	Возврат ЭтотОбъект;
КонецФункции

// Устанавливает прокси.
// 
// Параметры:
//  Прокси - ИнтернетПрокси, Неопределено - Прокси
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция УстановитьПрокси(Прокси) Экспорт
	ИнтернетПрокси = Прокси;
	Возврат ЭтотОбъект;
КонецФункции

// Перенаправит запрос по новому Location, если сервер вернул ответ с кодом состояния 3XX.
// 
// Параметры:
//  Перенаправлять - Булево - Перенаправлять
//  ВыполнятьАутентификацию - Булево - Выполнять аутентификацию
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция ПеренаправлятьЗапрос(Перенаправлять = Истина, ВыполнятьАутентификацию = Ложь) Экспорт
	ПеренаправлятьЗапросПоНовомуURI = Перенаправлять;
	ВыполнятьАутентификациюПриПеренаправлении = ВыполнятьАутентификацию;
	Возврат ЭтотОбъект;
КонецФункции

// Эмуляция Сhrome.
// 
// Параметры:
//  Включить - Булево - Включить эмуляцию
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция ЭмуляцияБраузера(Включить = Истина) Экспорт
	РежимЭмуляцииБраузера = Включить;
	Возврат ЭтотОбъект;
КонецФункции

// Заголовки ответа.
// 
// Возвращаемое значение:
//  Массив из Структура - Заголовки ответа
Функция ЗаголовкиОтвета() Экспорт
	Возврат ЗаголовкиОтвета;
КонецФункции

// Код состояния.
// 
// Возвращаемое значение:
//  Число - Код состояния
Функция КодСостояния() Экспорт
	Возврат КодСостояния;
КонецФункции

// Очищает артефакты запроса и восстанавливает исходные настройки.
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция Закрыть() Экспорт
	УдалитьАртефакты();
	УстановитьНачальныеНастройки();
	Возврат ЭтотОбъект;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Отправляет HTTP запрос.
// 
// Параметры:
//  URL - Строка - URL
//  Метод - Строка - Метод
//  Тело - Строка - Простой текст, Адрес двоичных данных во временном хранилище
//       - Структура
//       - Соответствие из КлючИЗначение
//       - ДвоичныеДанные
//       - Файл
//       - Неопределено
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция ОтправитьЗапрос(URL, Метод, Тело = Неопределено)

	КодСостояния = 0;
	ЗаголовкиОтвета.Очистить();
	
	УдалитьАртефакты();
	
	Команда = НоваяКоманда();
	
	Если РежимЭмуляцииБраузера Тогда
		ЭмуляцияChrome(Команда);
	КонецЕсли;
	
	ДобавитьПараметрКоманды(Команда, "--url", URL);
	ДобавитьПараметрКоманды(Команда, "-X", Метод);
	
	ДобавитьШифрыВПараметрыКоманды(Команда);
	ДобавитьЗаголовкиВПараметрыКоманды(Команда);
	ДобавитьФайлДампаЗаголовковВПараметрыКоманды(Команда);
	ДобавитьПроксиВПараметрыКоманды(Команда);
	ДобавитьДанныеАутентификацииВПараметрыКоманды(Команда);
	ДобавитьПеренаправлениеЗапросаВПараметрыКоманды(Команда);
	
	Если Метод = "POST" Тогда
		ДобавитьТелоЗапросаВПараметрыКоманды(Команда, Тело);
	КонецЕсли;

	ВыполнитьКоманду(Команда);
	
	ПрочитатьЗаголовкиОтвета();
	
	Возврат ЭтотОбъект;
	
КонецФункции

Процедура УстановитьНачальныеНастройки()
	
	КодСостояния = 0;
	ИнтернетПрокси = Неопределено;
	
	ИмяПользователяНаСервере = "";
	ПарольПользователяНаСервере = "";
	СпособАутентификацииНаСервере = "";
	ПеренаправлятьЗапросПоНовомуURI = Ложь;
	ВыполнятьАутентификациюПриПеренаправлении = Ложь;
	
	НаборШифров = Новый Массив;
	ЗаголовкиЗапроса = Новый Соответствие();
	ЗаголовкиОтвета = Новый Массив();
	
	ЭмуляцияБраузера(Ложь);
	
КонецПроцедуры

Процедура ПрочитатьЗаголовкиОтвета()
	
	ЗаголовкиОтвета.Очистить();
	
	Если Не ЗначениеЗаполнено(ПутьКЗаголовкамОтвета) Тогда
		Возврат;	
	КонецЕсли;
	
	Текст = Новый ЧтениеТекста(ПутьКЗаголовкамОтвета, КодировкаТекста.UTF8);
	
	Строка = Текст.ПрочитатьСтроку();
	Пока Строка <> Неопределено Цикл
		
		Если СтрНайти(Строка, "HTTP/") = 1 Тогда
			Подстроки = СтрРазделить(Строка, " ");
			КодСостояния = Число(Подстроки[1]);
			ЗаголовкиОтвета.Очистить();
		КонецЕсли;
		
		ПозицияДвоеточия = СтрНайти(Строка, ":");
		Если ПозицияДвоеточия Тогда
			Запись = ЗаписьHTTPЗаголовка();
			Запись.Ключ = Сред(Строка, 1, ПозицияДвоеточия - 1);
			Запись.Значение = СокрЛП(Сред(Строка, ПозицияДвоеточия + 1));
			ЗаголовкиОтвета.Добавить(Запись);
		КонецЕсли;
		
		Строка = Текст.ПрочитатьСтроку();	
	КонецЦикла;
	
	Текст.Закрыть();
	
	УдалитьФайлПриНаличии(ПутьКЗаголовкамОтвета);
	
КонецПроцедуры

// Парсит заголовки из текста. 
// Текст должен содежрать пары ключ-значение. Значение от ключа должно быть разделено двоеточием. 
// Пары должны быть разделены символом переноса.
// 
// Параметры:
//  Текст - Строка - Текст
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение
Функция ЗаголовкиИзТекста(Текст)
	
	Заголовки = Новый Соответствие();
	
	Для НомерСтроки = 1 По СтрЧислоСтрок(Текст) Цикл
		
		Строка = СтрПолучитьСтроку(Текст, НомерСтроки);
		ПозицияДвоеточия = СтрНайти(Строка, ":");
		Если ПозицияДвоеточия Тогда
			Имя = СокрЛП(Сред(Строка, 1, ПозицияДвоеточия - 1));
			Значение = СокрЛП(Сред(Строка, ПозицияДвоеточия + 1));
			Заголовки.Вставить(Имя, Значение);
		КонецЕсли;
				
	КонецЦикла;
	
	Возврат Заголовки;
	
КонецФункции

Функция ЗаписьHTTPЗаголовка()
	Запись = Новый Структура();
	Запись.Вставить("Ключ", "");
	Запись.Вставить("Значение", "");
	Возврат Запись;
КонецФункции

// Преобразует структуру в тело запроса.
// 
// Параметры:
//  Тело	- Структура
//  		- Соответствие из КлючИЗначение
// 
// Возвращаемое значение:
//  Строка
Функция СтруктураВТелоЗапроса(Тело)
	
	Если Не (ТипЗнч(Тело) = Тип("Структура") Или ТипЗнч(Тело) = Тип("Соответствие")) Тогда
		Возврат Тело;
	КонецЕсли;

	КодируемыеСимволы = Новый Массив; // Массив из Строка
	КодируемыеСимволы.Добавить("&");
	КодируемыеСимволы.Добавить("=");
		
	ТелоЗапроса = "";

	Для Каждого КлючИЗначение Из Тело Цикл		
		Значение = XMLСтрока(КлючИЗначение.Значение);
		
		Для Каждого Символ Из КодируемыеСимволы Цикл
			Значение = СтрЗаменить(Значение, Символ, КодироватьСтроку(Символ, СпособКодированияСтроки.КодировкаURL));
		КонецЦикла;

		ТелоЗапроса = ТелоЗапроса 
			+ ?(ТелоЗапроса = "", "", "&")
			+ КлючИЗначение.Ключ + "=" + Значение;	
	КонецЦикла;	
	
	Возврат ТелоЗапроса;
	
КонецФункции

// Удаляет артефакты запроса.
Процедура УдалитьАртефакты()
	
	УдалитьФайлПриНаличии(ПутьКРезультату);
	УдалитьФайлПриНаличии(ПутьКЗаголовкамОтвета);
	УдалитьФайлПриНаличии(ПутьКЗаголовкамЗапроса);
	УдалитьФайлПриНаличии(ПутьКТелуЗапроса);
	
КонецПроцедуры

// Удаляет файл при наличии.
// 
// Параметры:
//  Путь - Строка - Путь к файлу
Процедура УдалитьФайлПриНаличии(Путь)
	
	Если Не ЗначениеЗаполнено(Путь) Тогда
		Возврат;
	КонецЕсли;
	
	Файл = Новый Файл(Путь);
	Если Файл.Существует() Тогда
		УдалитьФайлы(Путь);	
	КонецЕсли;
	
	Путь = "";
	
КонецПроцедуры

// Удаляет файл если пустой.
// 
// Параметры:
//  Путь - Строка - Путь к файлу
Процедура УдалитьФайлЕслиПустой(Путь)
	
	Если Не ЗначениеЗаполнено(Путь) Тогда
		Возврат;
	КонецЕсли;
		
	Файл = Новый Файл(Путь);
	Если Файл.Существует() Тогда
		Если Файл.Размер() = 0 Тогда
			УдалитьФайлы(Путь);	
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Путь = "";

КонецПроцедуры

// Обернуть кавычками строку.
// 
// Параметры:
//  Строка - Строка - Строка
// 
// Возвращаемое значение:
//  Строка - Обернуть кавычками
Функция ОбернутьКавычками(Строка)
	Возврат """" + Строка + """";
КонецФункции

// Прочитать файл JSON.
// 
// Параметры:
//  ПутьКФайлу - Строка - Путь к файлу
//  УдалятьФайл - Булево - Удалять файл
// 
// Возвращаемое значение:
//  Произвольный
Функция ПрочитатьФайлJSON(ПутьКФайлу, УдалятьФайл = Ложь) Экспорт
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.ОткрытьФайл(ПутьКФайлу);
	
	Результат = ПрочитатьJSON(ЧтениеJSON, Истина);

	ЧтениеJSON.Закрыть();
	
	Если УдалятьФайл Тогда
		УдалитьФайлы(ПутьКФайлу);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Дополняет массив МассивПриемник значениями из массива МассивИсточник.
//
// Параметры:
//  МассивПриемник - Массив из Произвольный - массив, в который необходимо добавить значения.
//  МассивИсточник - Массив из Произвольный - массив значений для заполнения.
//  ТолькоУникальныеЗначения - Булево - если истина, то в массив будут включены только уникальные значения.
//
Процедура ДополнитьМассив(МассивПриемник, МассивИсточник, ТолькоУникальныеЗначения = Ложь) Экспорт
	
	Если ТолькоУникальныеЗначения Тогда
		
		УникальныеЗначения = Новый Соответствие;
		
		Для Каждого Значение Из МассивПриемник Цикл
			УникальныеЗначения.Вставить(Значение, Истина);
		КонецЦикла;
		
		Для Каждого Значение Из МассивИсточник Цикл
			Если УникальныеЗначения[Значение] = Неопределено Тогда
				МассивПриемник.Добавить(Значение);
				УникальныеЗначения.Вставить(Значение, Истина);
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		Для Каждого Значение Из МассивИсточник Цикл
			МассивПриемник.Добавить(Значение);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция СпособАутентификацииНаСервереBasic()
	Возврат "basic";	
КонецФункции

Функция СпособАутентификацииНаСервереDigest()
	Возврат "digest";	
КонецФункции

#Область ПодготовкаКоманды

Функция НоваяКоманда()

	Путь = ПутьКИсполняемомуФайлу;
	Если Не ЗначениеЗаполнено(ПутьКИсполняемомуФайлу) Тогда
		Путь = "curl";
	КонецЕсли;
		
	Возврат ОбернутьКавычками(Путь);
	
КонецФункции

Процедура ДобавитьПараметрКоманды(Команда, Имя, Значение = "", Разделитель = " ")
	Команда = Команда + " " + Имя + ?(ЗначениеЗаполнено(Значение), Разделитель + Значение, "");
КонецПроцедуры

// Добавляет заголовки в параметры команды.
// 
// Параметры:
//  Команда - Строка - Команда
Процедура ДобавитьЗаголовкиВПараметрыКоманды(Команда)
	
	Если ЗаголовкиЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовкиТекст = "";
	Для Каждого КлючИЗначение Из ЗаголовкиЗапроса Цикл
		ЗаголовкиТекст = ЗаголовкиТекст 
			+ СтрШаблон("%1: %2", КлючИЗначение.Ключ, КлючИЗначение.Значение)
			+ Символы.ПС;	
	КонецЦикла;
	
	//@skip-check missing-temporary-file-deletion
	ПутьКЗаголовкамЗапроса = ПолучитьИмяВременногоФайла();
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст(ЗаголовкиТекст);
	ТекстовыйДокумент.Записать(ПутьКЗаголовкамЗапроса, "CESU-8");
	
	ДобавитьПараметрКоманды(Команда, "--header", "@" + ПутьКЗаголовкамЗапроса);
	
КонецПроцедуры

// Добавляет шифры в параметры команды.
// 
// Параметры:
//  Команда - Строка - Команда
Процедура ДобавитьШифрыВПараметрыКоманды(Команда)
	
	Если Не НаборШифров.Количество() Тогда
		Возврат;
	КонецЕсли;
		
	Шифры = СтрСоединить(НаборШифров, ",");
	ДобавитьПараметрКоманды(Команда, "--ciphers", Шифры);
	
КонецПроцедуры

// Добавляет тело запроса в параметры команды.
// 
// Параметры:
//  Команда - Строка - Команда
//  Тело - Строка - Простой текст, Адрес двоичных данных во временном хранилище
//       - Структура
//       - Соответствие из КлючИЗначение
//       - ДвоичныеДанные
//       - Файл
//       - Неопределено
Процедура ДобавитьТелоЗапросаВПараметрыКоманды(Команда, Тело)
	
	Если Тело = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Тело) = Тип("Строка") И ЭтоАдресВременногоХранилища(Тело) Тогда
		Данные = ПолучитьИзВременногоХранилища(Тело);	
	ИначеЕсли ТипЗнч(Тело) = Тип("Структура") Или ТипЗнч(Тело) = Тип("Соответствие") Тогда		
		Данные = СтруктураВТелоЗапроса(Тело);	
	Иначе
		Данные = Тело;
	КонецЕсли;
	
	Если ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
		
		//@skip-check missing-temporary-file-deletion
		ПутьКТелуЗапроса = ПолучитьИмяВременногоФайла();
		Данные.Записать(ПутьКТелуЗапроса);
		
		ДобавитьПараметрКоманды(Команда, "--data-binary", "@" + ПутьКТелуЗапроса);
		
	ИначеЕсли ТипЗнч(Данные) = Тип("Файл") Тогда
		
		Если Данные.Существует() Тогда
			ДобавитьПараметрКоманды(Команда, "--data-binary", "@" + Данные.ПолноеИмя);
		Иначе
			ВызватьИсключение СтрШаблон("Файл '%1' не существует", Данные.ПолноеИмя);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Данные) = Тип("Строка") Тогда
		
		ДобавитьПараметрКоманды(Команда, "--data-raw", ОбернутьКавычками(Данные));
		
	Иначе
		
		ВызватьИсключение СтрШаблон("Тип %1 не поддерживается в качестве тела запроса", ТипЗнч(Тело));
		
	КонецЕсли;
					
КонецПроцедуры

// Добавляет файл дампа заголовков в параметры команды.
// 
// Параметры:
//  Команда - Строка - Команда
Процедура ДобавитьФайлДампаЗаголовковВПараметрыКоманды(Команда)
	
	//@skip-check missing-temporary-file-deletion
	ПутьКЗаголовкамОтвета = ПолучитьИмяВременногоФайла();
	ДобавитьПараметрКоманды(Команда, "--dump-header", ПутьКЗаголовкамОтвета);
	
КонецПроцедуры

Процедура ДобавитьПроксиВПараметрыКоманды(Команда)
	
	Если ИнтернетПрокси = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Протокол = "http";
	Если ИнтернетПрокси.Порт() = 443 Тогда
		Протокол = "https";	
	КонецЕсли;
	
	ДобавитьПараметрКоманды(Команда, "--proxy", СтрШаблон("%1://%2", Протокол, ИнтернетПрокси.Сервер()));
	
	Если ЗначениеЗаполнено(ИнтернетПрокси.Пользователь) Тогда
		ДобавитьПараметрКоманды(Команда, "--proxy-user", СтрШаблон("%1:%2", ИнтернетПрокси.Пользователь, ИнтернетПрокси.Пароль));	
	КонецЕсли;
	
КонецПроцедуры

// Добавляет данные аутентификации на сервере в параметры команды.
// 
// Параметры:
//  Команда - Строка - Команда
Процедура ДобавитьДанныеАутентификацииВПараметрыКоманды(Команда)
	
	Если Не ЗначениеЗаполнено(ИмяПользователяНаСервере) Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПараметрКоманды(Команда, "--user", СтрШаблон("%1:%2", ИмяПользователяНаСервере, ПарольПользователяНаСервере));
 
 	Если СпособАутентификацииНаСервере = СпособАутентификацииНаСервереDigest() Тогда
 		ДобавитьПараметрКоманды(Команда, "--digest");
 	Иначе
 		ДобавитьПараметрКоманды(Команда, "--basic");
 	КонецЕсли;
 	
КонецПроцедуры

// Добавляет перенаправление запроса в параметры команды.
// 
// Параметры:
//  Команда - Строка - Команда
Процедура ДобавитьПеренаправлениеЗапросаВПараметрыКоманды(Команда)
	
	Если Не ПеренаправлятьЗапросПоНовомуURI Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыполнятьАутентификациюПриПеренаправлении Тогда
		ДобавитьПараметрКоманды(Команда, "--location-trusted");	
	Иначе
		ДобавитьПараметрКоманды(Команда, "--location");	
	КонецЕсли;
 	
КонецПроцедуры

Процедура ВыполнитьКоманду(Команда)
	
	//@skip-check missing-temporary-file-deletion
	ПутьКРезультату = ПолучитьИмяВременногоФайла();
	
	ДобавитьПараметрКоманды(Команда, "--silent");
	ДобавитьПараметрКоманды(Команда, "--output", ОбернутьКавычками(ПутьКРезультату));
	
	ЗапуститьПриложение(Команда,, Истина);
	
	УдалитьФайлПриНаличии(ПутьКЗаголовкамЗапроса);
	УдалитьФайлПриНаличии(ПутьКТелуЗапроса);
	УдалитьФайлЕслиПустой(ПутьКРезультату);
	
КонецПроцедуры

#КонецОбласти

#Область Эмуляция

// Эмуляция chrome.
// 
// Параметры:
//  Команда - Строка - Команда
Процедура ЭмуляцияChrome(Команда)
	
	УстановитьЗаголовкиChrome();
	ДобавитьШифрыChrome();
	
	Если Не ПеренаправлятьЗапросПоНовомуURI Тогда
		ПеренаправлятьЗапрос();
	КонецЕсли;
	
	ДобавитьПараметрКоманды(Команда, "--http2");
	ДобавитьПараметрКоманды(Команда, "--tlsv1.2");
	ДобавитьПараметрКоманды(Команда, "--compressed");
	
КонецПроцедуры

Функция УстановитьЗаголовкиChrome()
	Заголовки = ПолучитьМакет("ChromeHeaders").ПолучитьТекст(); 
	УстановитьЗаголовки(Заголовки);
	Возврат ЭтотОбъект;
КонецФункции

// Добавляет шифры chrome в набор.
// 
// Возвращаемое значение:
//  ОбработкаОбъект.cURL
Функция ДобавитьШифрыChrome()
	НаборШифров.Очистить();
	Возврат ДобавитьШифры("TLS_AES_128_GCM_SHA256,TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,ECDHE-ECDSA-AES128-GCM-SHA256,ECDHE-RSA-AES128-GCM-SHA256,ECDHE-ECDSA-AES256-GCM-SHA384,ECDHE-RSA-AES256-GCM-SHA384,ECDHE-ECDSA-CHACHA20-POLY1305,ECDHE-RSA-CHACHA20-POLY1305,ECDHE-RSA-AES128-SHA,ECDHE-RSA-AES256-SHA,AES128-GCM-SHA256,AES256-GCM-SHA384,AES128-SHA,AES256-SHA");
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Инициализация

УстановитьНачальныеНастройки();

#КонецОбласти

#КонецЕсли