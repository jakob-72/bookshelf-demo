package dto

import (
	"fmt"
	"reflect"
	"strconv"
	"strings"
)

func checkRequired(data any) error {
	val := reflect.ValueOf(data)
	for i := 0; i < val.NumField(); i++ {
		validateTag := val.Type().Field(i).Tag.Get("validate")
		if validateTag == "required" {
			field := val.Field(i)
			switch field.Kind() {
			case reflect.String:
				if field.String() == "" {
					return fmt.Errorf("%s is required", strings.Split(val.Type().Field(i).Tag.Get("json"), ",")[0])
				}
			case reflect.Int:
				if field.Int() == 0 {
					return fmt.Errorf("%s is required", strings.Split(val.Type().Field(i).Tag.Get("json"), ",")[0])
				}
			default:
				return fmt.Errorf("unsupported type %s", field.Kind())
			}
		}
	}
	return nil
}

func validate(data any) error {
	reflectValue := reflect.ValueOf(data)
	for i := 0; i < reflectValue.NumField(); i++ {
		field := reflectValue.Field(i)
		tags := reflectValue.Type().Field(i).Tag
		if tags.Get("maxLength") != "" {
			val, _ := strconv.Atoi(tags.Get("maxLength"))
			if len(field.String()) > val {
				return fmt.Errorf("%s must not exceed %s characters", strings.Split(tags.Get("json"), ",")[0], tags.Get("maxLength"))
			}
		}
		if tags.Get("min") != "" {
			val, _ := strconv.Atoi(tags.Get("min"))
			// ignore zero values
			if field.Kind() == reflect.Int && field.Int() == 0 {
				continue
			}
			if field.Int() < int64(val) {
				return fmt.Errorf("%s must be at least %s", strings.Split(tags.Get("json"), ",")[0], tags.Get("min"))
			}
		}
		if tags.Get("max") != "" {
			val, _ := strconv.Atoi(tags.Get("max"))
			if field.Int() > int64(val) {
				return fmt.Errorf("%s must be at most %s", strings.Split(tags.Get("json"), ",")[0], tags.Get("max"))
			}
		}
	}
	return nil
}
