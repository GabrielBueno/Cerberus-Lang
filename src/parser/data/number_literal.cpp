#include "number_literal.h"

namespace cerberus {
    IntegerLiteral::IntegerLiteral() {}

    IntegerLiteral::IntegerLiteral(int data) {
        _data = data;
    }

    int IntegerLiteral::data() {
        return _data;
    }

    void IntegerLiteral::set_data(int data) {
        _data = data;
    }
}

namespace cerberus {
    DoubleLiteral::DoubleLiteral() {}

    DoubleLiteral::DoubleLiteral(double data) {
        _data = data;
    }

    double DoubleLiteral::data() {
        return _data;
    }

    void DoubleLiteral::set_data(double data) {
        _data = data;
    }
}