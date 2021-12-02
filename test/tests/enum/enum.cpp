#include "tests_common.h"
#include "enum.pb.h"

enum class SimpleEnum {
    Invalid = 0,
    ValueOne = 1,
    ValueTwo = 2
};


class SimpleEnumConverter: public NanoPb::Converter::AbstractScalarConverter<SimpleEnum, ProtoSimpleEnum> {
public:
    static ProtoType encode(const LocalType& local){
        switch (local) {
            case SimpleEnum::Invalid:
                return ProtoSimpleEnum_Invalid;
            case SimpleEnum::ValueOne:
                return ProtoSimpleEnum_ValueOne;
            case SimpleEnum::ValueTwo:
                return ProtoSimpleEnum_ValueTwo;
        }
        return ProtoSimpleEnum_Invalid;
    };
    static LocalType decode(const ProtoType& local){
        switch (local) {
            case ProtoSimpleEnum_Invalid:
                return SimpleEnum::Invalid;
            case ProtoSimpleEnum_ValueOne:
                return SimpleEnum::ValueOne;
            case ProtoSimpleEnum_ValueTwo:
                return SimpleEnum::ValueTwo;
        }
        return SimpleEnum::Invalid;
    };

};

int testEnumItem(SimpleEnum local, ProtoSimpleEnum proto){
    int status = 0;

    auto localToProto = SimpleEnumConverter::encode(local);

    TEST(localToProto == proto);

    auto protoToLocal = SimpleEnumConverter::decode(proto);

    TEST(protoToLocal == local);

    return status;
}


int main() {
    int status = 0;

    status |= testEnumItem(SimpleEnum::Invalid,ProtoSimpleEnum_Invalid);
    status |= testEnumItem(SimpleEnum::ValueOne,ProtoSimpleEnum_ValueOne);
    status |= testEnumItem(SimpleEnum::ValueTwo,ProtoSimpleEnum_ValueTwo);


    return status;
}
