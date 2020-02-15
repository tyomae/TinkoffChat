//
//  printLogs.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 14/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import Foundation

// Для того чтобы скрыть логи необходимо открыть Build settings -> Swift compiler-Custom flag -> Other swift flag и  удалить значение для Debug «-D SHOW_LOGS». Чтобы показать логи необходимо добавить для Debug «-D SHOW_LOGS»

func print(_ any: Any) {
    #if SHOW_LOGS
    Swift.print(any)
    #endif
}
